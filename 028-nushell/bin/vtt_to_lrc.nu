# This script is ONLY intend to use in nushell REPL.

module internal {
    export def fatal [
        error: string
        help?: string
        exit_code: int = 1
    ] {
        use ../log.nu fatal
        fatal "vtt2lrc" $error $help $exit_code
    }

    # Collect vtt files at path
    #
    # The call MUST ensure `vtt_path` exsits and is readable.
    #
    # Returns a list of vtt file path: [*.vtt]
    export def collect_vtt_files [
        vtt_path: string
    ] {
        let target_type = $vtt_path | path type

        if ($target_type == "file") {
            if (not ($vtt_path | str ends-with ".vtt")) {
                # Expected *.vtt file name
                fatal "invalid vtt file name" "expected *.vtt file name"
            }

            return [$vtt_path]
        }

        if ($target_type == "dir") {
            return  (ls $vtt_path
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
    export def convert [
        file_path: string
    ] {
        let output_path = $file_path | str replace --regex "([^.]+)(\\..+)+" "$1.lrc"
        let input_contents = open $file_path --raw | decode utf-8
        mut data = []

        const STATE_WAITING = 0
        const STATE_COLLECTING = 1
        mut state = $STATE_WAITING
        mut curr_timestamp = null

        # vtt timestamp line format: 00:01.000 --> 00:04.000
        let timestamp_re = r#'(?<time>(\d+:)+\d+\.\d+) --> (\d+:)+\d+\.\d+'#

        for $line in ($input_contents | lines) {
            if ($state == $STATE_WAITING) {
                # Waiting for timestamp line
                if ($line =~ $timestamp_re) {
                    $curr_timestamp = $line | parse --regex $timestamp_re | get time | first
                    $state = $STATE_COLLECTING
                }
                continue
            } else if ($state == $STATE_COLLECTING) {
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
            let idx = $x.timestamp | str index-of '.'
            let timestamp = $x.timestamp | str substring 0..($idx - 1)
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
# * Path to a directory contains one or more vtt files. No recursive for safety.
export def vtt2lrc [
    vtt_path: string # Path to the vtt file (*.vtt) or directory contains vtt files.
] {
    use internal *

    if (not ($vtt_path | path exists)) {
        fatal "failed to open path" $"path ($vtt_path) not exists"
    }

    for $f in (collect_vtt_files $vtt_path) {
        convert $f
    }
}