# List all commands in nushell, optionally with given command type
@category default
@example "list all commands" { list-command }
@example "list all custom commands" { list-command -c }
@example "list all alias commands" { list-command -a }
@example "list all built-in and alias commands" { list-command -b -a }
@example "list all built-in and alias commands" { list-command -b -a }
@example "list all built-in commands whose catergory is strings" { list-command -b -g strings }
export def list-command [
    --category (-g): string # Filter commands with category types
    --built-in (-b) # List all built-int commands
    --keyword (-k) # List all keyword commands
    --alias (-a) # List all alias commands
    --custom (-c) # List all custom commands
] : nothing -> table {
    mut target_command_types: list<string> = []

    if $built_in {
        $target_command_types = ($target_command_types | append 'built-in')
    }

    if $keyword {
        $target_command_types = ($target_command_types | append 'keyword')
    }

    if $alias {
        $target_command_types = ($target_command_types | append 'alias')
    }

    if $custom {
        $target_command_types = ($target_command_types | append 'custom')
    }

    mut cmds = []

    if ($target_command_types | is-empty) {
        $cmds = help commands | select name category command_type description
    } else {
        $cmds = help commands | where {|cmd_info| $target_command_types | any {|cmd_type| $cmd_type == $cmd_info.command_type} } | select name category command_type description
    }

    if ($category | is-not-empty) {
        $cmds | where $it.category == $category
    } else {
        $cmds
    }
}
