module internal {
    export def fatal [error: string, help?: string, exit_code: int = 1] {
        use ../log.nu fatal
        fatal "history query" $error $help $exit_code
    }
}

# Query commands in history.
#
# Only support sqlite3 format history storage.
export def "history query" [
    --date (-d): datetime # Filter command by its execution time.
    --duration: duration # Filter commands with duration diffs from now.
    keyword: glob # Keyword to query command by its name.
]: oneof<nothing, string> -> list<string> {
    use internal *

    if not $nu.history-enabled {
        fatal "history not enabled."
    }

    if $env.config.history.file_format != "sqlite" {
        fatal $"only support sqlite format history storage format, now is \"($env.config.history.file_format)\"."
    }

    let database = if not ($nu.history-path | path exists) {
        fatal "history database not exists."
    } else {
        open $nu.history-path
    }

    # Sanity check?
    # let x = $database | query db "SELECT * FROM sqlite_master"
    # Columns in history table.
    # item_id, start_timestamp, command, session_id, hostname, cwd, duration, exit_status, idx
    $database | query db "SELECT start_timestamp,command_line FROM history ORDER BY start_timestamp DESC LIMIT 100"
}
