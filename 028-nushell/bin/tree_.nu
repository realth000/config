use std/assert

const PREFIX_BOTTOM_RIGHT_AND_DOWN = "├"
const PREFIX_BOTTOM_RIGHT = "└"
const PREFIX_BOTTOM = "│"
const PREFIX_RIGHT = "─"

type HistoryItem = record<curr: int, count: int, ignored: int>
type History = list<HistoryItem>
type State = record<layer_level: int, files_count: int, directories_count: int, paths: list<string>, history: History>
type Config = record<list_all: bool, list_dirs_only: bool, full_path: bool, max_level: oneof<int, nothing>, ls_args: list<string>, output_format: string, enable_color: bool, pattern: oneof<nothing, glob>>
type Ctx = record<state: State, config: Config, result: list<string>>

type Content = record<type: string, name: string>
type Contents = list<record<Content>>

module internal {
    export def list-at-path [ctx]: nothing -> any {
        mut ctx: Ctx = $ctx

        $ctx.state.layer_level += 1
        let layer_level = $ctx.state.layer_level
        if $ctx.config.max_level != null and $ctx.config.max_level <= $ctx.state.layer_level {
            $ctx.state.layer_level -= 1
            return $ctx
        }
        let entry_path = $ctx.state.paths | path join

        # Here we intend to pass all ls_args to the ls command but not worked:
        # ls is a built-in command so it does not accept list of args from
        # variables, the only way is construct args in place, that's why we have
        # a function `list-dir`.
        let targets = list-dir $ctx.config $entry_path
        let targets_count = $targets | length
        $ctx.state.history = $ctx.state.history | append {curr: -1, count: $targets_count, ignored: 0}
        mut layer: HistoryItem = $ctx.state.history | get $layer_level

        assert (($ctx.state.history | length) == ($layer_level + 1)) $"incorrect count of layers in state history, expected ($layer_level + 1), got ($ctx.state.history | length)"

        if $targets_count > 0 {
            for idx in 0..($targets_count - 1) {
                let entry = $targets | get $idx

                $layer = $layer | update curr {$in + 1}

                $ctx.state.history = $ctx.state.history | update $layer_level $layer
                let prefix = make-prefix $layer_level $ctx.state.history

                let path_prefix = if $ctx.config.full_path {
                    [...$ctx.state.paths, ""] | str join "/"
                } else {
                    ""
                }

                # colors:
                #   symlink ->
                #       exists? cyan + bold
                #       not exists? {fg: red} + bold
                #   dir -> blue + bold
                let file_info = if $ctx.config.enable_color {
                    mut part1 = ""
                    mut part2 = ""
                    if $entry.type == "symlink" {
                        let symlink_path = if ($entry.target | str starts-with "/") {
                            $entry.target
                        } else {
                            # Adding path prefix.
                            $ctx.state.paths | append $entry.target | str join '/'
                        }

                        if ($symlink_path | path exists) {
                            $part1 = colorize-file $entry
                            let symlink_info = ls -D -l $symlink_path | get -o 0
                            if symlink_info != null {
                                $part2 = $" -> (colorize-file $symlink_info)"
                            } else {
                                $part2 = $" -> ($entry.target)"
                            }
                        } else {
                            # Symlink target not exists.
                            $part1 = $"(ansi {fg: red, attr: bold})($entry.name)(ansi reset)"
                            $part2 = $" -> ($entry.target)"
                        }
                    } else if $entry.type == "dir" {
                        $part1 = $"(ansi {fg: blue, attr: bold})($entry.name)(ansi reset)"
                    } else {
                        $part1 = colorize-file $entry
                    }
                    $"($part1)($part2)"
                } else {
                    if $entry.type == "symlink" {
                        $"($entry.name) -> ($entry.target)"
                    } else {
                        $entry.name
                    }
                }

                $ctx = $ctx | record apply {result: {$in | append $"($prefix)($path_prefix)($file_info)"}}

                if $entry.type == "dir" {
                    $ctx.state.paths = $ctx.state.paths | append $entry.name
                    $ctx = list-at-path $ctx
                    $ctx.state.paths = $ctx.state.paths | drop 1

                    $ctx.state.directories_count += 1
                } else {
                    $ctx.state.files_count += 1
                }
            }
        }

        $ctx.state.layer_level -= 1
        $ctx.state.history = $ctx.state.history | drop 1

        return $ctx
    }

    export def collect-at-path [config: record, layer_level: int, entry_path: string]: nothing -> record<directories_count: int, files_count: int, content: record> {
        let config: Config = $config

        mut directories_count = 0
        mut files_count = 0
        mut contents: Contents = []
        if $config.max_level != null and $config.max_level <= $layer_level {
            return []
        }
        let output_format = $config.output_format

        # Sturctured output needs intermediate data.
        # We should have contents field here because only directories have this field.
        let entry_name = if $entry_path == "." {
            "."
        } else {
            $entry_path | path basename
        }
        mut entry_content_item = if ($entry_path | path type) == "dir" {
            {
                type: "directory"
                name: $entry_name
                contents: []
            }
        } else {
            {type: "file", name: $entry_name}
        }

        let targets = list-dir $config $entry_path

        for $target in $targets {
            let target_path = [
                $entry_path
                ($target | get name)
            ] | path join

            if ($target_path | path type) == "dir" {
                $directories_count += 1

                let next_level = (collect-at-path
                    $config
                    ($layer_level + 1)
                    $target_path
                )
                $directories_count += ($next_level | get directories_count)
                $files_count += ($next_level | get files_count)
                let target_content_info = $next_level | get content
                $entry_content_item = $entry_content_item | record apply {contents: {$in | append $target_content_info}}
            } else {
                $files_count += 1

                let target_content_info = {
                    type: "file"
                    name: ($target | get name | path basename)
                }
                $entry_content_item = $entry_content_item | record apply {contents: {$in | append $target_content_info}}
            }
        }

        {
            directories_count: $directories_count
            files_count: $files_count
            content: $entry_content_item
        }
    }

    def list-dir [config: record, target: string] {
        let config: Config = $config

        let ls_args = $config.ls_args
        let list_all = $config.list_all
        let list_dirs_only = $config.list_dirs_only
        let pattern = $config.pattern
        let filter_ignored_ones = {|entry|
            # Return false to exclude $entry.
            if (not $list_all) and ($entry.name | str starts-with ".") {
                return false
            }

            if $list_dirs_only and ($entry.type != "dir") {
                return false
            }

            if $pattern != null and ($entry.type != "dir") {
                let pattern_str = $pattern | into string
                let re = $pattern_str | str replace "." "\\." | str replace "*" ".*" | str replace "?" ".?"
                return ($entry.name =~ $re)
            }

            true
        }

        ls -s -l --all=("-a" in $ls_args) $target | where $filter_ignored_ones
    }

    def repeat-str [str: string, times: int] {
        if $times < 0 {
            error make $"invalid repeat times in `repeat-str`: ($times)"
        }

        mut out = ""

        mut t = 0
        while $t < $times {
            $out += $str
            $t += 1
        }

        return $out
    }

    def make-prefix [layer_level: int, history]: nothing -> string {
        let curr_layer = $history | get $layer_level
        let is_last_item_in_current_level = is-at-end-of-layer $curr_layer
        let layers_count = $history | length

        mut prefix = ""

        for layer in ($history | take ($layers_count - 1)) {
            if (is-at-end-of-layer $layer) {
                $prefix = $prefix ++ (repeat-str " " 4)
            } else {
                $prefix = $prefix ++ $PREFIX_BOTTOM ++ (repeat-str " " 3)
            }
        }

        if $is_last_item_in_current_level {
            $prefix = $prefix ++ $PREFIX_BOTTOM_RIGHT ++ (repeat-str $PREFIX_RIGHT 2) ++ " "
        } else {
            $prefix = $prefix ++ $PREFIX_BOTTOM_RIGHT_AND_DOWN ++ (repeat-str $PREFIX_RIGHT 2) ++ " "
        }

        $prefix
    }

    def is-at-end-of-layer [item]: nothing -> bool {
        let curr = $item | get curr
        let ignored = $item | get ignored
        let count = $item | get count
        assert (($curr + $ignored) < $count) "too many items counted in layer"
        $curr + $ignored == ($count) - 1
    }

    def colorize-file [file_info: record<name: string, type: string, mode: string>]: nothing -> string {
        match $file_info.type {
            symlink => $"(ansi {fg: cyan, attr: bold})($file_info.name)(ansi reset)"
            dir => $"(ansi {fg: blue, attr: bold})($file_info.name)(ansi reset)"
            file => {
                let perms = $file_info.mode | split chars
                if $perms.2 == 'x' or $perms.5 == 'x' or $perms.8 == 'x' {
                    $"(ansi {fg: green, attr: bold})($file_info.name)(ansi reset)"
                } else {
                    $file_info.name
                }
            }
            _ => $file_info.name
        }
    }
}

# Like the Linux `tree` command but for nushell.
#
# This command implements part of the original `tree` command and some kind compatible.
#
# By default the output is plain text, while nuon and json format are supported with flags `--nuon` and `--json, -J`.
#
# Behavior differences:
#
# - On all platforms, only "." prefixed contents are regarded as hidden files.
# - When output plain text with colors, files with x perm for any users are regarded as "executable", rendered in green color.
#   - that is, files have any 'x' perm in "--x--x--x" is executable.
# - Use with glob, the glob is applied on file name not full path. Only `?`, `*` and `.` are supported in the glob pattern.
@category filesystem
@example "List contents in current directory." { tree }
@example "List contents in another directory." { tree path-to-folder }
@example "Input the directory to list by piping. This will override the one in flags" { "path-to-folder" | tree }
@example "Output in plain text format." { tree }
@example "Output in plain text format with color." { tree -C }
@example "Output in nuon table format." { tree --nuon }
@example "Output in json format." { tree -J }
export def tree [
    --all (-a) # List all files, including hidden files.
    --dir (-d) # List directories only, files wil be ignored.
    --full (-f) # Print full relative path to current work directory.
    --level (-L) : int # Set the max directory depth when listing.
    --nuon # Print output in nuon format.
    --json (-J) # Print output in json format.
    --color (-C) # Enable colorization, only works for plain text output.
    --pattern (-P) : glob # Pattern to filter the output. Only items match the pattern will be shown.
    path?: string # Root path to list, default to current directory.
]: oneof<nothing, string> -> string {
    use internal *

    let input = $in

    let root = if $input != null and (($input | describe) == "string") {
        $input
    } else if $path != null {
        $path
    } else {
        "."
    }

    if $pattern != null {
        let s = $pattern | into string
        if ($s | str contains "/") {
            error make --unspanned {
                msg: $"`/` is not supported in glob pattern."
            }
        }
    }

    mut config: Config = {
        list_all: false
        list_dirs_only: false
        full_path: false
        max_level: null
        ls_args: []
        output_format: "plain"
        enable_color: false
        pattern: $pattern
    }

    if $all {
        $config.list_all = true
    }
    if $dir { $config.list_dirs_only = true }
    if $full { $config.full_path = true }
    if $level != null {
        if $level <= 0 {
            error make {
                msg: "Invalid max depth level value"
                labels: [
                    {
                        text: $"invalid value \"($level)\""
                        span: (metadata $level).span
                    }
                ]
                help: "The max directory depth level value should be an integer greater than 0"
            }
        }
        $config.max_level = $level
    }
    if $nuon { $config.output_format = "nuon" }
    if $json { $config.output_format = "json" }
    if $color { $config.enable_color = true }

    let output_format = $config.output_format
    if $output_format == "plain" {
        mut state: State = {
            layer_level: -1
            files_count: 0
            directories_count: 0
            paths: [$root]
            # `history` records all traversing state of all levels of layers.
            #
            # Type: list<record<curr: int, count: int>>
            #
            # That is, for each depth, we save:
            #
            # - The index of current node in current layer.
            # - The count of node in current depth.
            #
            # On each node of each layer, check all upper layers, for
            # each layer `i`, go upward from current node and find the node `j`
            # in layer `i`:
            #
            # - If node `j` is the last node of layer `i`, only print spaces
            #   for the positions of `i` layer.
            # - Otherwise, in layer `i`, we still have nodes after node `j` so
            #   when we go back to node `j`, that is, print '│' to indicate layer
            #   `i` is not finished.
            history: []
        }

        if $all {
            $config.ls_args = $config.ls_args | append "-a"
        }

        mut context = {
            state: $state
            config: $config
            result: []
        }

        let root_info = if $config.enable_color {
            $"(ansi {fg: blue, attr: bold})($root)(ansi reset)"
        } else {
            $root
        }

        $context = $context | record apply {result: {$in | append $root_info}}
        mut final_ctx: Ctx = list-at-path $context
        let directory_report = if $final_ctx.state.directories_count == 1 {
            $"($final_ctx.state.directories_count) directory"
        } else {
            $"($final_ctx.state.directories_count) directories"
        }
        let files_report = if $final_ctx.state.files_count == 1 {
            $"($final_ctx.state.files_count) file"
        } else {
            $"($final_ctx.state.files_count) files"
        }

        $final_ctx = $final_ctx | record apply {result: {$in | append ["", $"($directory_report), ($files_report)"]}}
        $final_ctx | get result | str join "\n"
    } else {
        let ret = collect-at-path $config -1 $root
        let directories_count = $ret | get directories_count
        let files_count = $ret | get files_count
        let content: record = $ret | get content
        let output = $content | append {type: "report", "directories": $directories_count, "files": $files_count}
        if $output_format == "json" {
            $output | to json
        } else if $output_format == "nuon" {
            $output
        }
    }
}
