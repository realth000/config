module internal {
    export def fatal [error: string, help?: string, exit_code: int = 1] {
        use ../log.nu fatal
        fatal "patch" $error $help $exit_code
    }

    export def expand-run-paths [cmd: string, input: string, on_path: closure] : nothing -> int {
        let path = $"($input)" | path expand
        if not ($path | path exists) {
            fatal $"path \"($path)\" not exists"
        }

        print $"[($cmd)] applying: ($path)"
        let ret = do -i $on_path $path | complete

        if ($ret.stdout | is-not-empty) {
            print $"(ansi grey)($ret.stdout)(ansi reset)"
        }

        if ($ret.stderr | is-not-empty) {
            print $"(ansi red)($ret.stderr)(ansi reset)"
        }

        if $ret.exit_code != 0 {
            return $ret.exit_code
        }

        print $"[($cmd)] done"
        return 0
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

    if (which ^patch | is-empty) {
        fatal "external patch command not found"
    }

    let payload = { |path|
            open $path | ^patch -s -f -p1
    }

    let ret = expand-run-paths "appatch" $path $payload
    if $ret != 0 {
        error make --unspanned {
            msg: $"failed to appatch"
            raw_code: $ret
        }
    }
}

# Reverse apply patch file from current directory.
#
# The command works like an alias to `patch -R -p1 < xxx.patch`.
#
# External `patch` command is required.
@category dev
@example "Reverse apply patch file from ./some-patch.patch" { unpatch ./some-patch.patch }
export def unpatch [
    path: string # File path to the patch to remove.
] {
    use internal *

    if (which ^patch | is-empty) {
        fatal "external patch command not found"
    }

    let payload = { |path|
        open $path | patch -R -s -f -p1
    }

    let ret = expand-run-paths "unpatch" $path $payload
    if $ret != 0 {
        error make --unspanned {
            msg: $"failed to unpatch"
            raw_code: $ret
        }
    }
}
