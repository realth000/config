# Check the input of pipeline is a specific type
#
# Return true if it is, otherwise return false
#
# An alias to ($in | describe) == $type
#
# This command is only intended to use in pipe.
#
# Examples:
#
#     1 | is int             # true
#     1 | is string          # false
#     [foo] | is list        # true
#     {|x| x+1} | is closure # true
export def is [type: string] : any -> bool {
   ($in | describe) == $type
}


# Transform the input to another value if input is null
#
# The "another value" can be:
#
# * A value, any type except closure.
# * A closure that produce the value.
#
# Examples:
#
#     1 | other 100     # 1
#     null | other 100  # 100
#     let foo = 100; 1 | other {|| $foo * 2}     # 1
#     let foo = 100; null | other {|| $foo * 2}  # 200
export def other [else_value: oneof<closure, any>] {
    # $in become nothing in the if clause, we need to bind it to another variable
    # at the very first begining.
    let input = $in

    if ($input | is "nothing") {
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
export def then [next: closure]: any -> any {
    let input = $in
    if (($input |describe) == "nothing") {
        return null
    }

    do $next $input
}

# Filter the first element in list that satisfy a predication
#
# Unfortunately we can not have a "where like" syntax `[] | first-where $in > 4`,
# the only pred we have is closure.
#
# Examples:
#
#     [] | first-where {|x| $x > 2}                  # nothing
#     [1,3,5] | first-where {|x| $x > 2}             # 3
#     ["foo","bar"] | first-where {|x| $x == "bar"}  # "bar"
export def first-where [pred: oneof<bool, closure>]: list -> any {
    let input = $in
    for $item in $input {
        if (do $pred $item) {
            return $item
        }
    }

    null
}
