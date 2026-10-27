module internal {
    export def fatal [error: string, help?: string, exit_code: int = 1] {
        use ../log.nu fatal
        fatal "patch" $error $help $exit_code
    }
}

# Apply patch file to current directory.
#
# The command works like an alias to `patch -p1 < xxx.patch`.
#
# External `patch` command is required.
@category dev
@example "Apply patch file from ./some-patch.patch" { appatch ./some-patch.patch }
export def appatch [
    path: string # File path to the patch to apply.
] {
    use internal *

    if not ($path | path exists) {
        fatal "path not exists"
    }

    if (which ^patch | is-empty) {
        fatal "external patch command not found"
    }

    open $path | ^patch -p1
}

# Reverse apply patch file from current directory.
#
# The command works like an alias to `patch -R -p1 < xxx.patch`.
#
# External `patch` command is required.
@category dev
@example "Reverse apply patch file from ./some-patch.patch" { unapply ./some-patch.patch }
export def unpatch [
    path: string # File path to the patch to remove.
] {
    use internal *

    if not ($path | path exists) {
        fatal "file not exists"
    }

    if (which ^patch | is-empty) {
        fatal "external patch command not found"
    }

    open $path | ^patch -R -p1
}
