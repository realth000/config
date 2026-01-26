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
use ./bin/edit_config.nu ec
