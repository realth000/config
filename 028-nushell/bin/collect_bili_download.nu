# Collect downloaded audio files from the original download dir.
#
# Copy, rename and save in the `output` directory.

let output_dir = "output"

if not ($output_dir | path exists) {
    mkdir $output_dir
}

let dirs = ls * | where $it.type == "dir"

for dir in $dirs {
    let p_dir = $dir | get name

    let entry_json_file = $p_dir | path join "entry.json"
    if not ($entry_json_file | path exists) {
        print $"($p_dir): entry.json not found, skip"
        continue
    }

    let metadata = open $entry_json_file
    let title = $metadata | get -o title
    let type_tag = $metadata | get -o type_tag
    let page = $metadata | get -o page_data | get -o page
    let part = $metadata | get -o page_data | get -o part

    if $title == null or $type_tag == null or $page == null or $part == null {
        print $"($p_dir): title[($title)] or type_tag[($type_tag)] or page[($page)] or part[($part)] not found, skip"
        continue
    }

    let data_dir = $p_dir | path join $type_tag
    if not ($data_dir | path exists) {
        print $"($p_dir): data_dir not exists, skip"
        continue
    }

    let audio_file = $data_dir | path join "audio.m4s"
    if not ($audio_file | path exists) {
        print $"($p_dir): audio.m4s not exists, skip"
        continue
    }

    let part_id = $page | fill -a right -c "0" -w 3
    let output_file_name = $"($title)-($part_id)-($part).mp3"
    let output_file_path = $output_dir | path join $output_file_name

    cp $audio_file $output_file_path
    print $"($p_dir): ($output_file_name) ok"
}
