import sys


for arg in sys.argv[1:]:
	print(int.from_bytes(arg.encode(), byteorder="big"))
