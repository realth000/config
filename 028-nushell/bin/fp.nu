def is_null_value [input] {
    if ($input | is "nothing") {
        true
    } else if ($input | is string) and ($input | is-empty) {
        true
    } else if ($input | is list) and ($input | is-empty) {
        true
    } else if ($input | is record) and ($input | is-empty) {
        true
    } else if ($input | is table) and ($input | is-empty) {
        true
    } else {
        false
    }
}

# Check the input of pipeline is a specific type
#
# Return true if it is, otherwise return false
#
# An alias to ($in | describe) == $type
#
# This command is only intended to use in pipe
@deprecated "See `is` command in the functional plugin instead"
@category filters
@example "Check a variable is int" { 1 | is int } --result true
@example "Check a variable is string" { 1 | is string } --result false
@example "Check a variable is list" { [1] | is list } --result true
@example "Check a variable is integer list" { [1] | is list<int> } --result true
export def is [type: string]: any -> bool {
    let ty = $in | describe

    if $ty =~ "list<.*>" and $type == "list" {
        true
    } else if $ty =~ "record<.*>" and $type == "record" {
        true
    } else if $ty =~ "table<.*>" and $type == "table" {
        true
    } else {
        $ty == $type
    }
}

# Transform the input to another value if input is null
#
# Null value includes:
#
# - `null`
# - Empty string
# - Empty list
# - Empty record
# - Empty table
#
# Similar to the `default` command but works on null values
#
# The "another value" can be:
#
# * A value, any type except closure
# * A closure that produce the value
#
# See `then` for the opposite operation (do something when input is non-null)
@deprecated "See `other` command in the functional plugin instead"
@category filters
@example "Use the original value on non-null value" { 1 | other 100 } --result 1
@example "Use the given fallback value on null value" { null | other 100 } --result 100
@example "Use the given fallback value on empty string" { '' | other 100 } --result 100
@example "Use the given fallback value on empty list" { [] | other 100 } --result 100
@example "Use and map the given fallback value on null value" { let foo = 100; null | other {|| $foo * 2} } --result 200
export def other [else_value: oneof<closure, any>] {
    

    # $in become nothing in the if clause, we need to bind it to another variable
    # at the very first begining.
    let input = $in

    if (is_null_value $input) {
        if ($else_value | is closure) {
            do $else_value
        } else {
            $else_value
        }
    } else {
        $input
    }
}

# Do something if input is not null
#
# Null value includes:
#
# - `null`
# - Empty string
# - Empty list
# - Empty record
# - Empty table
#
# See `other` for the opposite operation (do something when input is null)
@deprecated "See `then` command in the functional plugin instead"
@category filters
@example "Use another value on non-null value" { 1 | then 100 } --result 100
@example "Use and map another value on non-null value" { let foo = 100; 1 | then {|| $foo * 2} } --result 200
@example "Keep the original value if input is null value" { [] | then 100 } --result []
export def then [next: oneof<closure, any>]: any -> any {
    let input = $in
    if (is_null_value $input) {
        $input
    } else if ($next | is closure) {
        do $next $input
    } else {
        $next
    }
}

# Filter the first element in list that satisfy a predication
#
# Unfortunately we can not have a "where like" syntax `[] | first-where $in > 4`,
# the only pred we have is closure
@deprecated "See `first-where` command in the functional plugin instead"
@category filters
@example "Filter on empty list" { [] | first-where {|x| $x > 2}} --result nothing
@example "Filter on integer list" { [1,3,5] | first-where {|x| $x > 2}} --result 3
@example "Filter on string list" { ["foo", "bar"] | first-where {|x| $x =~ "a*"}} --result "bar"
export def first-where [pred: oneof<bool, closure>]: list<any> -> any {
    let input = $in
    for $item in $input {
        if (do $pred $item) {
            return $item
        }
    }

    null
}
