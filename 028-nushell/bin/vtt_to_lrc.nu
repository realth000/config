# This script is ONLY intend to use in nushell REPL.

module internal {

    # Extract the start time from vtt line text
    #
    # Support two formats:
    #
    # 1. Without hour: 00:01.000 --> 00:04.000
    # 2. With hour: 00:00:01.000 --> 00:04.000
    #
    # We dont't care the end time so it's not strictly verified
    #
    # Returns:
    #
    # - A record if time matches: { year: string | nothing, minute: string, second: string, millisecond: string }
    # - Nothing if time not matches
    def extract_time_from_string [time_str: string] {
        # With hour:
        #
        # '00:00:01.000 --> 00:04.000' | parse --regex '...'
        #
        # ╭───┬──────────────┬────┬────┬────┬─────┬──────────┬────┬────┬─────┬──────────╮
        # │ # │   capture0   │ h1 │ m1 │ s1 │ ms1 │ capture5 │ m2 │ s2 │ ms2 │ capture9 │
        # ├───┼──────────────┼────┼────┼────┼─────┼──────────┼────┼────┼─────┼──────────┤
        # │ 0 │ 00:00:01.000 │ 00 │ 00 │ 01 │ 000 │          │    │    │     │          │
        # ╰───┴──────────────┴────┴────┴────┴─────┴──────────┴────┴────┴─────┴──────────╯
        #
        # Without hour:
        #
        # '00:01.000 --> 00:04.000' | parse --regex '...'
        #
        # ╭───┬──────────┬────┬────┬────┬─────┬───────────┬────┬────┬─────┬──────────╮
        # │ # │ capture0 │ h1 │ m1 │ s1 │ ms1 │ capture5  │ m2 │ s2 │ ms2 │ capture9 │
        # ├───┼──────────┼────┼────┼────┼─────┼───────────┼────┼────┼─────┼──────────┤
        # │ 0 │          │    │    │    │     │ 00:01.000 │ 00 │ 01 │ 000 │ 00:      │
        # ╰───┴──────────┴────┴────┴────┴─────┴───────────┴────┴────┴─────┴──────────╯
        let timestamp_re = r#'((?<h1>\d+):(?<m1>\d+):(?<s1>\d+)\.(?<ms1>\d+))|((?<m2>\d+):(?<s2>\d+)\.(?<ms2>\d+)) --> (\d+:)+\d+\.\d+'#
        if $time_str !~ $timestamp_re {
            return
        }

        let all_matches = $time_str | parse --regex $timestamp_re

        if ($all_matches | get h1 | describe | str contains "nothing") {
            # Without hour.

            let m = $all_matches | get m2 | first
            let s = $all_matches | get s2 | first
            let ms = $all_matches | get ms2 | first

            return {minute: $m, second: $s, millisecond: $ms}
        }

        # With hour.

        let h = $all_matches | get h1 | first
        let m = $all_matches | get m1 | first
        let s = $all_matches | get s1 | first
        let ms = $all_matches | get ms1 | first

        return {
            hour: $h
            minute: $m
            second: $s
            millisecond: $ms
        }
    }

    # Compose hour (optional), minute, second and millisecond into formatted string
    def compose_time_to_string [
        timestamp: record # Time record: { hour?: string, minute: string, second: string, millisecond: string }. Unfortunately we can not convert record with hours into `hour?` record so do not specify the type here
    ] {
        # hour is optional
        let hour = $timestamp.hour?
        let minute = $timestamp.minute
        let second = $timestamp.second
        let millisecond = $timestamp.millisecond
        if (($hour | describe) == "string") and ($hour != "00") {
            return $"($hour):($minute):($second).($millisecond)"
        } else {
            return $"($minute):($second).($millisecond)"
        }
    }

    export def fatal [error: string, help?: string, exit_code: int = 1] {
        use ../log.nu fatal
        fatal "vtt2lrc" $error $help $exit_code
    }

    # Collect vtt files at path
    #
    # The call MUST ensure `vtt_path` exsits and is readable
    #
    # Returns a list of vtt file path: [*.vtt]
    export def collect_vtt_files [vtt_path: string] {
        let target_type = $vtt_path | path type

        if $target_type == "file" {
            if not ($vtt_path | str ends-with ".vtt") {
                # Expected *.vtt file name
                fatal "invalid vtt file name" "expected *.vtt file name"
            }

            return [$vtt_path]
        }

        if $target_type == "dir" {
            return (ls $vtt_path
                | where { $in.type == "file" and ($in.name | str ends-with ".vtt") }
                | each { $in.name })
        }

        fatal "unsupported target type" $"path \"($vtt_path)\" is a \"($target_type)\""
    }

    # Convert vtt file to lrc file
    #
    # The output file name is automatically computed from the input `file_path`
    #
    # The caller MUST ensure `file_path` exists and is a valid vtt file with name "*.vtt"
    export def convert [file_path: string] {
        let output_path = if ($file_path | str ends-with ".mp3.vtt") or ($file_path | str ends-with ".wav.vtt") {
            $"($file_path | str substring 0..-9).lrc"
        } else if ($file_path | str ends-with ".flac.vtt") {
            $"($file_path | str substring 0..-10).lrc"
        } else {
            $file_path | str replace --regex "([^.]+)(\\..+)+" "$1.lrc"
        }
        let input_contents = open $file_path --raw | decode utf-8
        mut data: list<record<timestamp: record, content: string>> = []

        const STATE_WAITING = 0
        const STATE_COLLECTING = 1
        mut state = $STATE_WAITING
        mut curr_timestamp = null

        # vtt timestamp line format: 00:01.000 --> 00:04.000
        let timestamp_re = r#'(?<time>(\d+:)+\d+\.\d+) --> (\d+:)+\d+\.\d+'#

        for $line in ($input_contents | lines) {
            if $state == $STATE_WAITING {
                # Waiting for timestamp line
                let parsed_time = extract_time_from_string $line
                if ($parsed_time | describe) != "nothing" {
                    $curr_timestamp = $parsed_time
                    $state = $STATE_COLLECTING
                }
                continue
            } else if $state == $STATE_COLLECTING {
                if ($line | str trim | is-empty) {
                    $state = $STATE_WAITING
                    continue
                }

                # Collect contents
                $data = ($data | append {
                    timestamp: $curr_timestamp
                    content: ($line | str trim)
                })
                continue
            }

            fatal "invalid convert state" $"unreachable invalid convert state: ($state)"
        }

        let output_contents = $data | each {|x|
            let timestamp = compose_time_to_string $x.timestamp
            $"[($timestamp)]($x.content)"
        } | str join "\n"

        $output_contents | save -fp $output_path
        return
    }
}

# Convert vtt to lrc
#
# Command converts vtt format to lrc format
#
# This command ONLY collects *.vtt files from:
#
# * vtt file path
# * Path to a directory contains one or more vtt files. No recursive for safety
@category conversions
@example "Convert a single vtt file into lrc file" { vtt2lrc foo.vtt }
@example "Convert all vtt files in current directory into lrc files" { vtt2lrc . }
@example "Convert all vtt files in a directory into lrc files" { vtt2lrc path/to/foo/directory }
export def vtt2lrc [
    vtt_path: string # Path to the vtt file (*.vtt) or directory contains vtt files
] {
    use internal *

    if not ($vtt_path | path exists) {
        fatal "failed to open path" $"path ($vtt_path) not exists"
    }

    for $f in (collect_vtt_files $vtt_path) {
        convert $f
    }
}
