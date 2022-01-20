MAX_LEN_FELT = 31

def str_to_felt(text):
    if len(text) > MAX_LEN_FELT:
        raise Exception("Text length too long to convert to felt.")
    b_text = bytes(text, "UTF-8")
    return int.from_bytes(b_text, "big")

def felt_to_str(felt):
    length = (felt.bit_length() + 7) // 8
    return felt.to_bytes(length, byteorder="big").decode("utf-8")

def str_to_felt_array(text):
    # Break string into array of strings that meet felt requirements
    chunks = []
    for i in range(0, len(text), MAX_LEN_FELT):
        str_chunk = text[i:i+MAX_LEN_FELT]
        chunks.append(str_to_felt(str_chunk))
    return chunks

def uint256_to_int(uint256):
    return uint256[0] + uint256[1]*2**128

def uint256(val):
    return (val & 2**128-1, (val & (2**256-2**128)) >> 128)