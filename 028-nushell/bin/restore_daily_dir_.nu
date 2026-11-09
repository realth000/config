module internal {
    export def fatal [error: string, help?: oneof<string, nothing>, exit_code: int = 1] {
        use ../log.nu fatal
        fatal "restore-daily-dir" $error $help $exit_code
    }
}

# Restore a directory for today's daily use.
#
# The directory is named with month and day, `MMdd` format, e.g. 0101, 1130.
#
# If the directory not exists, create an empty directory.
#
# If the directory exists and it's content is old in the last year, optionally
# delete it and create an empty directory.
export def restore-daily-dir [] {
    use internal *

    let dir_name = date now | format date "%m%d"
    if not ($dir_name | path exists) {
        mkdir $dir_name
        return
    }

    let now_year = date now | format date "%Y" | into int
    for entry in (ls $dir_name) {
        let entry_year = $entry.modified | format date "%Y" | into int
        if ($entry_year - $now_year >= 0) {
            # Recent content.
            print $"recent content '($entry.name)' exists in directory, exit"
            return
        }
    }

    rm -rf $dir_name
    mkdir $dir_name
}
