import json

MAX_LEN_FELT = 31

def str_to_felt(text):
    if len(text) > MAX_LEN_FELT:
        raise Exception("Text length too long to convert to felt.")
    return int.from_bytes(text.encode(), "big")

data_name = []
data_symbol = []

for i in range(0, 100):
    data_name.append(str_to_felt(f"BASECAMP_04_TOKEN_{i}"))
    data_symbol.append(str_to_felt(f"BSC04_{i}"))
    
    
print(len(data_symbol))
print(data_name)
print(data_symbol)

with open('sample_name.json', 'w') as f:
    json.dump(data_name, f, separators=(" ", ":"))
    
with open('sample_symbol.json', 'w') as f:
    json.dump(data_symbol, f, separators=(" ", ":"))

print("Sample data saved.")


