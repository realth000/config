module internal {
    export def supported_build_types [] {
        [
            {
                name: deb
                type: system
                detection: {
                    directory: debian
                    file: [
                        [debian, changelog]
                    ]
                }
            }
            {
                name: "deb-src"
                type: system
                detection: {
                    directory: debian
                    file: [
                        [debian, changelog]
                    ]
                }
            }
            {
                name: cargo
                type: language
                detection: {
                    file: [Cargo.toml]
                }
            }
            {
                name: cmake
                type: language
                detection: {
                    file: [CMakeLists.txt]
                }
            }
            {
                name: go
                type: language
                detection: {
                    file: [go.mod]
                }
            }
            {
                name: npm
                type: language
                detection: {
                    file: [package-lock.json]
                }
            }
            {
                name: pnpm
                type: language
                detection: {
                    file: [pnpm-lock.yaml]
                }
            }
            {
                name: rpm
                type: system
                detection: {
                    file_glob: ["*.spec"]
                }
            }
            {
                name: srpm
                type: system
                detection: {
                    file_glob: ["*.spec"]
                }
            }
        ]
    }

    export def detect_build_type [] {
        let all_types = supported_build_types

        let language_types = $all_types | where $in.type == "language"

        let system_types = $all_types | where $in.type == "system"
    }

    def detect_type [build_type: record] {
        let detection = $build_type.detection

        if "file" in $detection {
            if ($detection.file | all {|x| ($x | path exists) and ($x | path type | $in == "file") }) {
                return true
            }
        }

        if "directory" in $detection {
            if ($detection.file | all {|x| ($x | path exists) and ($x | path type | $in == "dir") }) {
                return true
            }
        }

        if "file-glob" in $detection {
            if ($detection.file_glob | all {|x| glob $x | is-not-empty }) {
                return true
            }
        }

        return false
    }
}

# Auto build command (WIP)
#
# Run build command in current directory with build type detection
#
# Supported package types or project types:
#
# * deb
# * deb-src, deb source package (*.changes)
# * cargo
# * cmake
# * go
# * npm
# * pnpm
# * rpm
# * srpm, rpm source package
export def d [
    --type (-t): string # specify build type manually ()
    -s # build source package, if available for current packaging type.
    -d # ignore unmet dependency (only available when building deb packages)
    -c # clean build cache
] {
    use internal *

    for $build_type in (supported_build_types) {
        print ($build_type | describe)

        print ($build_type.detection | describe)

        print ($build_type.detection | columns | ("directory" in $in))

        print ($build_type.detection | columns | ("file" in $in))
    }
}
