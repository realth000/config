#!/bin/env nu

export def print-colors [] {
    for curr_color in [[color, code]; [black, 40], [red, 41], [green, 42], [yellow, 43], [blue, 44], [magenta, 45], [cyan, 46], [white, 47]] {
        let normal_text = $"(($curr_color.color + ':') | fill -w 8) (ansi -e ($curr_color.code)m)    (ansi reset)"
        let bright_code = $curr_color.code + 60
        let bright_text = $"(('bright_' + $curr_color.color + ':') | fill -w 15) (ansi -e ($bright_code)m)    (ansi reset)"

        print $"($normal_text)    ($bright_text)"
    }
}
