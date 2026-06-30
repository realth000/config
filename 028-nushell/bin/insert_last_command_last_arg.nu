module internal {
    export def fatal [error: string, help?: string, exit_code: int = 1] {
        use ../log.nu fatal

        fatal "insert-last-command-last-arg" $error $help $exit_code
    }
}

# Insert the last arg of last command in the nushell command history.
#
# This command works like '!$' but reedline sometimes do not convert
# text '!$' into the actual argument, it does not work well.
#
# Use this command to take replace of it.
@category history
@example "Insert the last arg in last command in nushell history" { insert-last-command-last-arg }
export def insert-last-command-last-arg [] {
    use internal *

    let history_file_path = $nu.history-path

    let history_file_format = $env.config.history.file_format

    # Get the last command from history.
    #
    # Note that no matter what kind of history file format, we are querying the last result of a list.
    let last_command = if $history_file_format == "plaintext" {
        open $history_file_path | lines | last
    } else if $history_file_format == "sqlite" {
        let history_db = open $history_file_path

        # Compatibility check: check if the schema of history table is recognized.
        #
        # 1. There should be a table called "history".
        # 2. There should be a column called "command_line" in the "history" table.
        #
        # If the above conditions are all met, the query result should be 1, otherwise 0 or throws an error.
        let compatible_history_table = $history_db | query db "SELECT COUNT(*) FROM PRAGMA_TABLE_INFO('history') WHERE name = 'command_line'" | get "COUNT(*)" | first

        if $compatible_history_table != 1 {
            # Not compatible
            fatal "command not available: history table in history sqlite database is not compatible"

            return 1
        }

        $history_db | query db "SELECT command_line FROM history ORDER BY rowid DESC LIMIT 1" | get command_line | last
    } else {
        # Unknown history file format.
        fatal $"command not available: unknown history file format: ($history_file_format)"

        return 1
    }

    if $last_command == null {

        # No history available, return peacefully.
        return 0
    }

    # Extract last arg from last command.

    # Match double quoted text
    #
    # '"xxxx"'
    # or
    # 'foo $"xxxx"'
    # or
    # 'foo "xxxx"'
    let double_re = r#'(^|\$| )(".*")$'#

    # Match single quoted text
    let single_re = r#'(\'.*\')$'#

    let last_arg = if ($last_command | str ends-with '"') and ($last_command =~ $double_re) {
        $last_command | parse --regex $double_re | get capture1 | first
    } else if ($last_command | str ends-with "'") and ($last_command =~ $single_re) {
        $last_command | parse --regex $single_re | get capture0 | first
    } else {
        # Test in repl:
        #
        # let input = "foo bar"
        # let all_chars = $input | split chars | reverse
        # mut idx = 0
        # for ch in $all_chars { if $ch == ' ' {break;}; $idx += 1 }
        # print $"last=($all_chars | take $idx | reverse | str join)"
        let all_chars = $last_command | split chars | reverse

        mut idx = 0

        for $ch in $all_chars {
            if $ch == ' ' {
                break
            }

            $idx += 1
        }

        $all_chars | take $idx | reverse | str join
    }

    commandline edit -i $last_arg
}
