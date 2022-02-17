import json
for i in range(1,101):
	myJson = {}
	myJson["name"] = "Gan generated image %s" % i
	myJson["image"] = "https://gateway.pinata.cloud/ipfs/Qmd9PegtrP3c7r6uJMWTC3CMCQUTVTzqg8jtmZsxnuUAeD/" + str(i) + ".jpeg"
	print(myJson)
	with open("assets/%s.json" % i, 'w') as outfile:
		outfile.write(json.dumps(myJson))
	# json.dumps("assets/%s.json\÷\//\" % i, myJson)
	