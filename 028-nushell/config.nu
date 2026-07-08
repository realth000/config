# Configure configs.

$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.keybindings ++= [
    {
        name: prepend_sudo
        modifier: alt
        keycode: char_/
        mode: emacs
        event: [
            {edit: MoveToStart}
            {edit: InsertString, value: "sudo "}
            {edit: MoveToEnd}
        ]
    }
    # Add the last argument in last command.
    # The command fixes various issue in the built-in '!$' insert string.
    {
        name: insert_last_token
        modifier: alt
        keycode: char_.
        mode: emacs
        event: [
            {send: ExecuteHostCommand, cmd: "insert-last-command-last-arg"}
        ]
    }
]
$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.algorithm = "substring"
$env.config.history.file_format = "sqlite"
$env.config.datetime_format.table = "%Y-%m-%d %H:%M:%S"
$env.config.datetime_format.normal = "%Y-%m-%d %H:%M:%S"

# Download carapace from https://github.com/carapace-sh/carapace-bin/releases/latest
$env.config.completions.external.completer = {|spans|
    # Reset locale so that carapace does not report errors.
    if $nu.os-info.name == "linux" {
        export-env { $env.LC_ALL = "C" }
    }

    # Return null if external completer returns empty result so that fallback to
    # nushell internal completion.
    carapace $spans.0 nushell ...$spans | from json | if ($in | is-empty) { null } else { $in }
}

# Commands

use ./bin/build.nu d
use ./bin/edit_config.nu ec
# use ./bin/fp.nu *
use ./bin/list_command.nu list-command
use ./bin/vtt_to_lrc.nu vtt2lrc
use ./bin/insert_last_command_last_arg.nu insert-last-command-last-arg
use ./bin/tree_.nu tree
use ./bin/invoke_.nu invoke
