module internal {
    export def fatal [error: string, help?: string, exit_code: int = 1] {
        use ../log.nu fatal
        fatal "unlines" $error $help $exit_code
    }
}

# Join lines of strings into a single string.
#
# Runs like `$input | str join $separator`.
#
# Default behavior:
#
# Separator depends on runtime platform:
#
# - On Linux and macOS, join by lf, '\n'.
# - On Windows, join by crlf, '\r\n'.
# - To force join by '\n', use `--lf`.
# - To force join by '\r\n', use `--crlf`.
#
# EOL style is not changed:
#
# - To ensure the output is ended with platform separator, use `--eol`.
# - To ensure the output is ended with (also joined with) '\n', use `--eol --lf`.
# - To ensure the output does not have trailing line, use `--no-eol`.
#   - `--no-eol` does not work with `--lf` or `--crlf`, that is, `--no-eol` always trims the last trailing `\n` and `\r\n`.
#
# Error occurs if conflict flags present:
#
# - `--eol` and `--no-eol`.
# - `--lf` and `--crlf`.
#
# Empty lines are kept:
#
# - To skip empty lines, use `--skip-empty, -e`.
# - Multiple trailing empty lines are not trimmed.
#   - With `--no-eol`, only the last line is trimmed.
@category strings
@example "Join by default separator on Linux or macOS" { ["foo", "bar"] | unlines } --result 'foo\nbar'
@example "Join by default separator on Windows" { ["foo", "bar"] | unlines } --result 'foo\r\nbar'
@example "Join, ensure eol on Linux or macOS" { ["foo", "bar"] | unlines --eol } --result 'foo\nbar\n'
@example "Join, ensure eol on Windows" { ["foo", "bar"] | unlines --eol } --result 'foo\r\nbar\r\n'
@example 'Join, ensure eol "\n"' { ["foo", "bar"] | unlines --eol --lf } --result 'foo\nbar\n'
@example "Join, ensure noeol" { ["foo", "bar", "\n"] | unlines --no-eol } --result 'foo\nbar'
export def unlines [
    --skip-empty (-e) # Skip empty lines.
    --eol # Ensure end of line, `char newline`, at the end of output.
    --no-eol # Ensure no end of line, '\r\n' or '\n', at the end of output.
    --crlf # Use `\r\n` to join between lines.
    --lf # Use `\n` to join between lines.
]: list<string> -> string {
    # Check conflict flags.
    if $no_eol and $eol {
        fatal "conflict flags: `--no-eol` and `--eol`".
    }

    if $crlf and $lf {
        fatal "conflict flags: `--crlf` and `--lf`".
    }

    let $input = $in
    if ($input | is-empty) {
        return ""
    }

    let lines_count = $input | length
    if $lines_count == 1 {
        return $input.0
    }

    let sep = if $lf {
        "\n"
    } else if $crlf {
        "\r\n"
    } else {
        char newline
    }

    # SAFETY: ensured not less than 2 items.
    let first_line: string = $input.0
    let last_line = $input | last
    let working_lines = $input | skip 1 | drop 1
    mut ret: list<string> = [$first_line]
    for line in $working_lines {
        if $skip_empty and ($line | is-empty) {
            continue
        }

        $ret ++= [$sep, $line]
    }

    if $eol {
        if $last_line == $sep {
            $ret ++= [$last_line]
        } else if ($last_line == "\r\n") or ($last_line == "\n") {
            $ret ++= [$last_line]
        } else {
            $ret ++= [$sep, $last_line, $sep]
        }
    } else if $no_eol {
        if ($last_line != "\n") and ($last_line != "\r\n") {
            $ret ++= [$sep, $last_line]
        } else {
            # Do nothing.
        }
    } else {
        $ret ++= [$sep, $last_line]
    }

    $ret | str join ""
}
