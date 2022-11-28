rm build/*.json
for filename in $(find . -type f -name '*.cairo'); do
    name=$(basename -- "$filename")
    name="${name%.*}"
    starknet-compile $filename --output "build/$name.json"
done
