export def info [keyword: string, content: string] {
    print $"[($keyword)] ($content)"
}

export def fatal [
    keyword: string
    error: string
    help?: string
    exit_code: int = 1
] {
    error make --unspanned {
        msg: $"[($keyword)] ($error)"
        help: $help
        raw_code: exit_code
    }
}
