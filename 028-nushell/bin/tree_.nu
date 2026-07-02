# This nushell script can be used both in repl and other scripts.
#
# For reference only, here is the original `tree` command help message:
#
# ```bash
# $ tree --help
# usage: tree [-acdfghilnpqrstuvxACDFJQNSUX] [-H baseHREF] [-T title ]
#         [-L level [-R]] [-P pattern] [-I pattern] [-o filename] [--version]
#         [--help] [--inodes] [--device] [--noreport] [--nolinks] [--dirsfirst]
#         [--charset charset] [--filelimit[=]#] [--si] [--timefmt[=]<f>]
#         [--sort[=]<name>] [--matchdirs] [--ignore-case] [--fromfile] [--]
#         [<directory list>]
#   ------- Listing options -------
#   -a            All files are listed.
#   -d            List directories only.
#   -l            Follow symbolic links like directories.
#   -f            Print the full path prefix for each file.
#   -x            Stay on current filesystem only.
#   -L level      Descend only level directories deep.
#   -R            Rerun tree when max dir level reached.
#   -P pattern    List only those files that match the pattern given.
#   -I pattern    Do not list files that match the given pattern.
#   --ignore-case Ignore case when pattern matching.
#   --matchdirs   Include directory names in -P pattern matching.
#   --noreport    Turn off file/directory count at end of tree listing.
#   --charset X   Use charset X for terminal/HTML and indentation line output.
#   --filelimit # Do not descend dirs with more than # files in them.
#   --timefmt <f> Print and format time according to the format <f>.
#   -o filename   Output to file instead of stdout.
#   ------- File options -------
#   -q            Print non-printable characters as '?'.
#   -N            Print non-printable characters as is.
#   -Q            Quote filenames with double quotes.
#   -p            Print the protections for each file.
#   -u            Displays file owner or UID number.
#   -g            Displays file group owner or GID number.
#   -s            Print the size in bytes of each file.
#   -h            Print the size in a more human readable way.
#   --si          Like -h, but use in SI units (powers of 1000).
#   -D            Print the date of last modification or (-c) status change.
#   -F            Appends '/', '=', '*', '@', '|' or '>' as per ls -F.
#   --inodes      Print inode number of each file.
#   --device      Print device ID number to which each file belongs.
#   ------- Sorting options -------
#   -v            Sort files alphanumerically by version.
#   -t            Sort files by last modification time.
#   -c            Sort files by last status change time.
#   -U            Leave files unsorted.
#   -r            Reverse the order of the sort.
#   --dirsfirst   List directories before files (-U disables).
#   --sort X      Select sort: name,version,size,mtime,ctime.
#   ------- Graphics options -------
#   -i            Don't print indentation lines.
#   -A            Print ANSI lines graphic indentation lines.
#   -S            Print with CP437 (console) graphics indentation lines.
#   -n            Turn colorization off always (-C overrides).
#   -C            Turn colorization on always.
#   ------- XML/HTML/JSON options -------
#   -X            Prints out an XML representation of the tree.
#   -J            Prints out an JSON representation of the tree.
#   -H baseHREF   Prints out HTML format with baseHREF as top directory.
#   -T string     Replace the default HTML title and H1 header with string.
#   --nolinks     Turn off hyperlinks in HTML output.
#   ------- Input options -------
#   --fromfile    Reads paths from files (.=stdin)
#   ------- Miscellaneous options -------
#   --version     Print version and exit.
#   --help        Print usage and this help message and exit.
#   --            Options processing terminator.
# ```

const PREFIX_BOTTOM_RIGHT_AND_DOWN = "├"
const PREFIX_BOTTOM_RIGHT = "└"
const PREFIX_RIGHT = "─"

module internal {
    export def list_at_path [
        ctx: record<
            state: record<
                indent_level: int,
                indent_line_width: int,
                indent_just_changed: bool,
                files_count: int,
                directories_count: int,
                paths: list<string>,
                ls_args: list<string>,
            >,
            config: record<
                list_all: bool,
                list_dirs_only: bool,
                follow_links: bool,
                full_path: bool,
                max_level: oneof<int, nothing>,
            >,
        >,
    ] : nothing -> record {
        mut ctx = $ctx
        $ctx.state.indent_level += 1
        $ctx.state.indent_just_changed = true

        let targets = (ls -a ($ctx.state.paths | path join))
        let targets_count = $targets | length
        for idx in 0..($targets_count - 1)  {
            let entry = $targets | get $idx

            let prefix0 = if $idx < ($targets_count - 1) {
                $PREFIX_BOTTOM_RIGHT_AND_DOWN
            } else {
                $PREFIX_BOTTOM_RIGHT
            }

            let prefix1 = repeate_str $PREFIX_RIGHT ([(4 * ($ctx.state.indent_level + 1) - 2), 0] | math max)

            let file_info = if $ctx.config.full_path {
                $entry | get name
            } else {
                $entry | get name | path basename 
            }

            if not $ctx.config.list_dirs_only {
                print $"($prefix0)($prefix1) ($file_info)"
            }

            if $ctx.state.indent_just_changed {
                $ctx.state.indent_just_changed = false
            }

            if $entry.type == "dir" {
                $ctx.state.paths = $ctx.state.paths | append $entry.name
                $ctx = list_at_path $ctx
                $ctx.state.paths = $ctx.state.paths | drop 1
            }
        }


        $ctx.state.indent_level -= 1
        $ctx.state.indent_just_changed = true

        return $ctx
    }

    def repeate_str [ str: string, times: int] {
        if $times < 0 {
            error make $"invalid repeate times in `repeat_str`: ($times)"
        }

        mut out = ""

        mut t = 0
        while $t < $times {
            $out += $str
            $t += 1
        }

        return $out
    }
}

# Like external command but written in nushell.
@category filesystem
@example "List files and directories in current folder" { tree }
export def tree [
    --all (-a) # List all files, including hidden files.
    --dir (-d) # List directories only, files wil be ignored.
    --link (-l) # Follow symbolic links.
    --full (-f) # Print full relative path to current work directory.
    --level (-L) : int # Set the max directory depth when listing.
] {
    use internal *

    mut state = {
        indent_level: -1
        indent_line_width: 2
        indent_just_changed: false
        files_count: 0
        directories_count: 0
        paths: ["."]
        ls_args: []
    }
    mut config = {
        list_all: false
        list_dirs_only: false
        follow_links: false
        full_path: false
        max_level: null
    }

    mut context = {state: $state, config: $config}

    if $all {
        $config.list_all = true
        $state.ls_args = $state.ls_args | append "-a"
    }
    if $dir { $config.list_dirs_only = true }
    if $link { $config.follow_links = true }
    if $full { $config.full_path = true }
    if $level != null {
        if $level <= 0 {
            error make {
                msg: "Invalid max depth level value"
                labels: [{ text: $"invalid value \"($level)\"", span: (metadata $level).span }]
                help: "The max directory depth level value should be an integer greater than 0"
            }
        }
        $config.max_level = $level
    }

    # print $"max_level is ($config.max_level), type is ($config.max_level | describe)"

    let _ = list_at_path $context
}
