# Configure configs.

$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.keybindings ++= [
    {
        name: insert_last_token
        modifier: alt
        keycode: char_.
        mode: emacs
        event: [
            { edit: InsertString, value: "!$" }
            { send: Enter }
        ]
    }
    {
        name: prepend_sudo
        modifier: alt
        keycode: char_/
        mode: emacs
        event: [
            { edit: MoveToStart }
            { edit: InsertString, value: "sudo " }
            { edit: MoveToEnd }
        ]
    }
]
$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.algorithm = "fuzzy"

# Commands

use ./bin/edit_config.nu ec
use ./bin/vtt_to_lrc.nu vtt2lrc
