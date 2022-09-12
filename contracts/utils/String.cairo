%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem, assert_le, assert_250_bit
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.pow import pow

from contracts.utils.Array_sekai import concat_arr

const SHORT_STRING_MAX_LEN = 31;  // The maximum character length of a short string
const SHORT_STRING_MAX_VALUE = 2 ** 248 - 1;  // The maximum value for a short string of 31 characters (= 0b11...11 = 0xff...ff)
const CHAR_SIZE = 256;  // Each character is encoded in utf-8 so 8-bit
const EXTRACT_CHAR_MASK = 2 ** 248 - CHAR_SIZE;  // Mask to retreive the last character (= 0b11...1100000000)
const STRING_MAX_LEN = 2 ** 15;  // The maximum index fot felt* in one direction given str[i] for i in [-2**15, 2**15) to allow back propagation for string inverse read/write operations

@storage_var
func strings_str(str_id: felt, short_string_index: felt) -> (short_string: felt) {
}

@storage_var
func strings_len(str_id: felt) -> (length: felt) {
}

//
// String storage
//

//
// Gets a string from storage based on its ID
//
// Parameters:
//   str_id (felt): The ID of the string to return
//
// Returns:
//   str_len (felt): The length of the string
//   str (felt*): The string itself (in char array format)
//
func String_get{
    syscall_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(str_id: felt) -> (str_len: felt, str: felt*) {
    alloc_locals;
    let (str) = alloc();

    let (str_len) = strings_len.read(str_id);

    if (str_len == 0) {
        return (str_len, str);
    }

    let (full_ss_len, rem_char_len) = unsigned_div_rem(str_len, SHORT_STRING_MAX_LEN);

    // Initiate loop with # of short strings and the last short string length
    _get_ss_loop(str_id, full_ss_len, rem_char_len, str);
    return (str_len, str);
}

func _get_ss_loop{
    syscall_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(str_id: felt, ss_index: felt, ss_len: felt, str: felt*) {
    let (ss_felt) = strings_str.read(str_id, ss_index);
    // Get and separate each character in the short string
    _get_ss_char_loop(ss_felt, ss_index, ss_len, str);

    if (ss_index == 0) {
        return ();
    }
    // Go to the previous short string
    _get_ss_loop(str_id, ss_index - 1, SHORT_STRING_MAX_LEN, str);
    return ();
}

func _get_ss_char_loop{
    syscall_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(ss_felt: felt, ss_position: felt, char_index: felt, str: felt*) {
    // Must be checked at beginning of function here for the case where str_len = x * SHORT_STRING_MAX_LEN
    if (char_index == 0) {
        return ();
    }

    // Extract last character from short string
    let (ss_rem, char) = String_extract_last_char(ss_felt);

    // Store the character in the correct position, i.e. SHORT_STRING_INDEX * SHORT_STRING_MAX_LEN + INDEX_IN_SHORT_STRING
    assert str[ss_position * SHORT_STRING_MAX_LEN + char_index - 1] = char;
    _get_ss_char_loop(ss_rem, ss_position, char_index - 1, str);
    return ();
}

//
// Sets a string in storage based on its ID
//
// Parameters:
//   str_id (felt): The ID of the string to store
//   str_len (felt): The length of the string
//   str (felt*): The string itself (in char array format)
//
func String_set{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    str_id: felt, str_len: felt, str: felt*
) {
    alloc_locals;
    with_attr error_message("String : exceeding max string length 2^15") {
        assert_le(str_len, STRING_MAX_LEN);
    }
    strings_len.write(str_id, str_len);

    if (str_len == 0) {
        return ();
    }

    let (full_ss_len, rem_char_len) = unsigned_div_rem(str_len, SHORT_STRING_MAX_LEN);

    // Initiate loop with # of short strings and the last short string length
    _set_ss_loop(str_id, full_ss_len, rem_char_len, str);
    return ();
}

func _set_ss_loop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    str_id: felt, ss_index: felt, ss_len: felt, str: felt*
) {
    // Accumulate all characters in a felt and write it
    _set_ss_char_loop(str_id, 0, ss_index, ss_len, ss_len, str);

    if (ss_index == 0) {
        return ();
    }
    // Go to the previous short string
    _set_ss_loop(str_id, ss_index - 1, SHORT_STRING_MAX_LEN, str);
    return ();
}

func _set_ss_char_loop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    str_id: felt, ss_felt_acc: felt, ss_position: felt, ss_len: felt, char_index: felt, str: felt*
) {
    if (char_index == 0) {
        strings_str.write(str_id, ss_position, ss_felt_acc);
        return ();
    }

    let (char_offset) = pow(CHAR_SIZE, ss_len - char_index);
    let ss_felt = ss_felt_acc + str[ss_position * SHORT_STRING_MAX_LEN + char_index - 1] * char_offset;
    _set_ss_char_loop(str_id, ss_felt, ss_position, ss_len, char_index - 1, str);
    return ();
}

//
// Deletes a string in storage based on its ID
//
// Parameters:
//   str_id (felt): The ID of the string to delete
//
func String_delete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(str_id: felt) {
    alloc_locals;
    let (str_len) = strings_len.read(str_id);

    if (str_len == 0) {
        return ();
    }

    strings_len.write(str_id, 0);

    let (ss_cells, _) = unsigned_div_rem(str_len, SHORT_STRING_MAX_LEN);
    _delete_loop(str_id, ss_cells);
    return ();
}

func _delete_loop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    str_id: felt, ss_index: felt
) {
    strings_str.write(str_id, ss_index, 0);

    if (ss_index == 0) {
        return ();
    }

    _delete_loop(str_id, ss_index - 1);
    return ();
}

//
// String manipulation
//

//
// Converts a felt to its utf-8 string value
// e.g. 12345 -> 0x3132333435 -> (5, [49, 50, 51, 52, 53]) -> "12345"
//
// Parameters:
//   elem (felt): The felt value to convert
//
// Returns:
//   str_len (felt): The length of the string
//   str (felt*): The string itself (in char array format)
//
func String_felt_to_string{range_check_ptr}(elem: felt) -> (str_len: felt, str: felt*) {
    let (str_seed) = alloc();
    return _felt_to_string_loop(elem, str_seed, 0);
}

func _felt_to_string_loop{range_check_ptr}(elem: felt, str_seed: felt*, index: felt) -> (
    str_len: felt, str: felt*
) {
    alloc_locals;
    with_attr error_message("String : exceeding max string length 2^15") {
        assert_le(index, STRING_MAX_LEN);
    }
    let str_arr = cast(str_seed - 1, felt*);

    let (new_elem, unit) = unsigned_div_rem(elem, 10);
    assert str_arr[0] = unit + '0';  // add '0' (= 48) to a number in range [0, 9] for utf-8 character code
    if (new_elem == 0) {
        return (index + 1, str_arr);
    }

    let is_lower = is_le(elem, new_elem);
    if (is_lower != 0) {
        return (index + 1, str_arr);
    }

    return _felt_to_string_loop(new_elem, str_arr, index + 1);
}

//
// Joins to strings together and adding a '/' in between if needed
// e.g. path_join("sekai.gg", "assets") -> "sekai.gg/assets"
//
// Parameters:
//   base_len (felt): The first string's length
//   base (felt*): The first string
//   str_len (felt): The second string's length
//   str (felt*): The second string
//
// Returns:
//   str_len (felt): The length of the string
//   str (felt*): The string itself (in char array format)
//
func String_path_join{range_check_ptr}(base_len: felt, base: felt*, str_len: felt, str: felt*) -> (
    res_len: felt, res: felt*
) {
    if (base[base_len - 1] == '/') {
        return concat_arr(base_len, base, str_len, str);
    }

    assert base[base_len] = '/';  // append the '/' to the first string
    return concat_arr(base_len + 1, base, str_len, str);
}

//
// Appends two strings together
// ** Wrapper of Array.concat_arr **
//
// Parameters:
//   base_len (felt): The first string's length
//   base (felt*): The first string
//   str_len (felt): The second string's length
//   str (felt*): The second string
//
// Returns:
//   str_len (felt): The length of the string
//   str (felt*): The string itself (in char array format)
//
func String_append{range_check_ptr}(base_len: felt, base: felt*, str_len: felt, str: felt*) -> (
    res_len: felt, res: felt*
) {
    return concat_arr(base_len, base, str_len, str);
}

//
// Extracts the last character from a short string and returns the characters before as a short string
// Manages felt up to 2**248 - 1 (instead of unsigned_div_rem which is limited by rc_bound)
// _On the down side it requires BitwiseBuiltin for the whole call chain_
//
// Parameters:
//   ss (felt): The shortstring
//
// Returns:
//   ss_rem (felt): All the characters before as a short string
//   char (felt): The last character
//
func String_extract_last_char{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(ss: felt) -> (
    ss_rem: felt, char: felt
) {
    with_attr error_message("String : exceeding max short string value 2^248 - 1") {
        // We should assert 248 bit here but for now it's "enough" for starters
        // assert_le is limited by RANGE_CHECK_BOUND
        assert_250_bit(ss);
    }

    let (masked_value) = bitwise_and(ss, EXTRACT_CHAR_MASK);
    let ss_rem = masked_value / CHAR_SIZE;
    let char = ss - masked_value;

    return (ss_rem, char);
}
