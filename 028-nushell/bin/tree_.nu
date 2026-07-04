# This nushell script can be used both in repl and scripts.

use std/assert

const PREFIX_BOTTOM_RIGHT_AND_DOWN = "├"
const PREFIX_BOTTOM_RIGHT = "└"
const PREFIX_BOTTOM = "│"
const PREFIX_RIGHT = "─"

module internal {
    export def list-at-path [
        ctx: record<
            state: record<
                layer_level: int,
                files_count: int,
                directories_count: int,
                paths: list<string>,
                ls_args: list<string>,
                history: list<record<curr: int, count: int, ignored: int>>,
            >,
            config: record<
                list_all: bool,
                list_dirs_only: bool,
                full_path: bool,
                max_level: oneof<int, nothing>,
            >
        >
    ]: nothing -> record {
        mut ctx = $ctx
        $ctx.state.layer_level += 1
        let layer_level = $ctx.state.layer_level
        if $ctx.config.max_level != null and $ctx.config.max_level <= $ctx.state.layer_level {
            $ctx.state.layer_level -= 1
            return $ctx
        }

        # Here we intend to pass all ls_args to the ls command but not worked:
        # ls is a built-in command so it does not accept list of args from
        # variables, the only way is construct args in place, that's why we have
        # a function `list-dir`.
        #
        # Likely it is a bug in nushell because for external commands we can do
        # `^ls ...$args`.
        #
        # But if the count of args grows, it is tedious to list all the
        # combinations of args.
        #
        # For now, an alternative solution is spawn a nushell instance and pass
        # the ls command to it, it works, but **extremly slow**. So use the
        # handly version.
        #
        # let targets = nu --no-history -c $"ls (echo ...$ctx.state.ls_args | str join ' ') ($ctx.state.paths | path join) | to nuon" | from nuon
        let targets = list-dir $ctx.state.ls_args ($ctx.state.paths | path join)
        let targets_count = $targets | length
        $ctx.state.history = $ctx.state.history | append {curr: -1, count: $targets_count, ignored: 0}
        mut layer = $ctx.state.history | get $layer_level

        assert (($ctx.state.history | length) == ($layer_level + 1)) $"incorrect count of layers in state history, expected ($layer_level + 1), got ($ctx.state.history | length)"

        if $targets_count > 0 {
            for idx in 0..($targets_count - 1) {
                let entry = $targets | get $idx

                let should_ignore = (
                    # Not show hidden attribute.
                    ((not $ctx.config.list_all) and ($entry | get name | str starts-with "."))
                    or
                    # Only show directory.
                    ($ctx.config.list_dirs_only and (($entry | get type) != "dir"))
                )
                if $should_ignore {
                    $layer = $layer | update ignored {$in + 1}
                    continue
                }

                $layer = $layer | update curr {$in + 1}

                $ctx.state.history = $ctx.state.history | update $layer_level $layer
                let prefix = make-prefix $layer_level $ctx.state.history

                let file_info = if $ctx.config.full_path {
                    [...$ctx.state.paths, ($entry | get name)] | str join "/"
                } else {
                    $entry | get name
                }

                print $"($prefix)($file_info)"

                if $entry.type == "dir" {
                    $ctx.state.paths = $ctx.state.paths | append $entry.name
                    $ctx = list-at-path $ctx
                    $ctx.state.paths = $ctx.state.paths | drop 1
                }
            }
        }

        $ctx.state.layer_level -= 1
        $ctx.state.history = $ctx.state.history | drop 1

        return $ctx
    }

    def list-dir [args: list<string>, target: string] {
        ls -s --all=("-a" in $args) --long=("-l" in $args) $target
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

    def make-prefix [layer_level: int, history: list<record<curr: int, count: int, ignored: int>>]: nothing -> string {
        let curr_layer = $history | last
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

    def is-at-end-of-layer [layer: record<curr: int, count: int, ignored: int>]: nothing -> bool {
        let curr = $layer | get curr
        let ignored = $layer | get ignored
        let count = $layer | get count
        assert (($curr + $ignored) < $count) "too many items counted in layer"
        $curr + $ignored == ($count) - 1
    }
}

# Like the `tree` command in bash but written in nushell.
#
# This command implements part of the original `tree` command and have some
# different behavior.
#
# Output is plain text, not structured data.
#
# Behavior differences:
#
# - On all platforms, only "." prefix named ones are considered as hidden files.
@category filesystem
@example "List files and directories in current folder" { tree }
export def tree [
    --all (-a) # List all files, including hidden files.
    --dir (-d) # List directories only, files wil be ignored.
    --full (-f) # Print full relative path to current work directory.
    --level (-L) : int # Set the max directory depth when listing.
] {
    use internal *

    mut state = {
        layer_level: -1
        files_count: 0
        directories_count: 0
        paths: ["."]
        ls_args: ["-s"]
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
    mut config = {
        list_all: false
        list_dirs_only: false
        full_path: false
        max_level: null
    }

    if $all {
        $config.list_all = true
        $state.ls_args = $state.ls_args | append "-a"
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

    mut context = {state: $state, config: $config}

    print "."
    let _ = list-at-path $context
}
