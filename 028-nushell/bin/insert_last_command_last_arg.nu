# Extract the last arg from command.
def extract-last-arg []: string -> string {
    let last_command = $in

    let double_re = r#'(^|\$| )(".*")$'#
    # Match single quoted text
    let single_re = r#'(\'[^']*\')$'#
    let backtick_re = r#'(`[^`]*`)$'#
    let brace_re = r#'({[^{}]*})$'#
    let bracket_re = r#'(\[[^\[\]]*\])$'#
    let paren_re = r#'(\([^\(\)]*\))$'#
    let last_arg = if ($last_command | str ends-with '"') and ($last_command =~ $double_re) {
        $last_command | parse --regex $double_re | get capture1 | first
    } else if ($last_command | str ends-with "'") and ($last_command =~ $single_re) {
        $last_command | parse --regex $single_re | get capture0 | first
    } else if ($last_command | str ends-with "`") and ($last_command =~ $backtick_re) {
        $last_command | parse --regex $backtick_re | get capture0 | first
    } else if ($last_command | str ends-with "}") and ($last_command =~ $brace_re) {
        $last_command | parse --regex $brace_re | get capture0 | first
    } else if ($last_command | str ends-with "]") and ($last_command =~ $bracket_re) {
        $last_command | parse --regex $bracket_re | get capture0 | first
    } else if ($last_command | str ends-with ")") and ($last_command =~ $paren_re) {
        $last_command | parse --regex $paren_re | get capture0 | first
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
            if $ch == " " {
                break
            }
            $idx += 1
        }
        $all_chars | take $idx | reverse | str join
    }

    $last_arg
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
    let history_file_path = $nu.history-path
    let history_file_format = $env.config.history.file_format

    # Get the last command from history.
    #
    # Note that no matter what kind of history file format, we are querying the last result of a list.
    let last_command = if true  {
        history | last | get command | str trim --right
    }

    if $last_command == null {

        # No history available, return peacefully.
        return 0
    }

    let last_arg = $last_command | extract-last-arg

    commandline edit -i $last_arg
}
