use ../unlines_.nu unlines
use std/assert

const LF = "\n"
const CRLF = "\r\n"

let sep = char newline

let cases = [
    [args, input, expected];
    [[], ["foo", "bar"], $"foo($sep)bar"]
    [[], ["foo", "bar", "\n"], $"foo($sep)bar($sep)\n"]
    [[], ["foo", "\n", "bar", "\n", "\n"], $"foo($sep)\n($sep)bar($sep)\n($sep)\n"]
    [[--lf], ["foo", "bar"], $"foo($LF)bar"]
    [[--lf], ["foo", "bar", "\n"], $"foo($LF)bar($LF)\n"]
    [[--lf], ["foo", "bar", "\r\n"], $"foo($LF)bar($LF)\r\n"]
    [[--crlf], ["foo", "bar"], $"foo($CRLF)bar"]
    [[--crlf], ["foo", "bar", "\n"], $"foo($CRLF)bar($CRLF)\n"]
    [[--crlf], ["foo", "bar", "\r\n"], $"foo($CRLF)bar($CRLF)\r\n"]
    [[--eol], ["foo", "bar"], $"foo($sep)bar($sep)"]
    [[--eol], ["foo", "bar", "\n"], $"foo($sep)bar($sep)"]
    [[--eol], ["foo", "bar", "\n", "\n"], $"foo($sep)bar($sep)\n($sep)"]
    [[--no-eol], ["foo", "bar", "\n"], $"foo\nbar"]
    [[--no-eol], ["foo", "bar", "\r\n"], $"foo\nbar"]
    [[--no-eol], ["foo", "bar", "\r\n"], $"foo\nbar"]
    [[--skip-empty], ["foo", "bar"], $"foo($sep)bar"]
    [[--skip-empty], ["foo", "", "bar"], $"foo($sep)bar"]
    [[--skip-empty], ["foo", "", "", "bar"], $"foo($sep)bar"]
    [[--skip-empty], ["foo", "\n", "bar"], $"foo($sep)\n($sep)bar"]
]

for t in $cases {
    assert equal (
        $t.input |
        unlines --skip-empty=(--skip-empty in $t.args)
            --eol=(--eol in $t.args)
            --no-eol=(--no-eol in $t.args)
            --crlf=(--crlf in $t.args)
            --lf=(--lf in $t.args)
    ) $t.expected
}
