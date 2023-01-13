## Install Dependencies
```
protostar install OpenZeppelin/cairo-contracts@v0.5.1
```
## Build Contract
```
protostar build --cairo-path ./lib/cairo_contracts/src
```

## Set private key for local Devnet
```
touch .pkey_local
```

## Deploy TDERC20
```
protostar -p devnet declare ./build/TDERC20.json --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto

protostar -p devnet deploy 0x0015b1abb9eb21e540a1c7550648837d5eec1481fa5ec112c30724f532be553e --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto -i 327360763727160756219953 327360763727160756219953 0 0 2229195667427071297143342999133310373395611149256223784343082293246336070172 2229195667427071297143342999133310373395611149256223784343082293246336070172

protostar -p devnet call --contract-address 0x07b12625c751f82ca98838311eae7e77c96f45f6898b9cb1d971522b75a48474 --function "name"
```

## Deploy Players Registry
```
protostar -p devnet declare ./build/players_registry.json --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto

protostar -p devnet deploy 0x05db7eb921593a29e41ec904de97b7f69db02a532da935b06a3c8f2678512971 --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto -i 2229195667427071297143342999133310373395611149256223784343082293246336070172
```

## Deploy dummy token
```
protostar -p devnet declare ./build/dummy_token.json --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto

protostar -p devnet deploy 0x05fee25dd4509206023b8152c666071b7062be7994cb02774a83e5798a2227bc --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto -i 323287074983686041199982 4478027 100000000000000000000 0 2229195667427071297143342999133310373395611149256223784343082293246336070172

protostar -p devnet call --contract-address 0x01f8c9352a4abe221410102bb2b50c1632a3f1a848e99daca15d8e24c2f2a917 --function "balanceOf" --inputs 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c
```

## Deploy dummy ERC721
```
protostar -p devnet declare ./build/TDERC721_metadata.json --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto

protostar -p devnet deploy 0x006e4142da0432bfd1d0b08ab6ad35540411a08c8ed835ada1247e682b0d687e --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto -i 6072054417219596849 6072054417219596849 2229195667427071297143342999133310373395611149256223784343082293246336070172 3 184555836509371486644298270517380613565396767415278678887948391494588524912 181013377130045435659890581909640190867353010602592517226438742938315085926 2194400143691614193218323824727442803459257903 199354445678

protostar -p devnet call --contract-address 0x00ecaefea9409cbd5d902c6bc945e86f0def1eb74530548f07e299711a803832 --function "name"
```

## Deploy Evaluator
```
protostar -p devnet declare ./build/Evaluator.json --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto

protostar -p devnet deploy 0x01de252d12a27e2233a60ee98d9fb41b663546efe08f2337405005466c5a4968 --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --private-key-path ./.pkey_local --max-fee auto -i 3479185155418709781260110042681682557762817310123084794228617398345162589300 1687307194201823146165879336460317775082889390706489258260652307512029170628 3 418183676802850952047778386865892026516049867646541533392501794020817647666 891879604995047580946814926839936343068015829211578073217599494212711262487
```

## Set Random Values
```
starknet invoke --address 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801 --function set_random_values --abi ./build/Evaluator_abi.json  --inputs 100 2 7 4 8 7 6 1 7 6 5 4 8 8 5 6 3 8 2 8 6 5 7 3 1 8 6 7 3 6 8 1 7 3 8 2 3 4 5 2 5 7 3 3 4 4 4 5 8 1 7 1 5 7 1 3 2 5 7 8 8 7 1 8 4 1 6 2 1 6 6 4 7 2 1 2 3 5 1 3 8 6 5 5 2 7 8 4 6 4 5 4 6 1 6 4 5 3 5 8 3 0 --feeder_gateway_url http://127.0.0.1:5050  --gateway_url http://127.0.0.1:5050

starknet invoke --address 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801 --function set_random_values --abi ./build/Evaluator_abi.json  --inputs 100 1 1 2 1 1 1 2 2 2 2 1 2 2 2 2 1 2 1 1 1 1 2 2 2 2 2 2 2 2 1 2 1 1 2 1 2 2 1 2 1 1 1 2 2 2 2 2 1 1 2 2 2 2 2 2 1 2 1 1 1 1 2 1 2 2 1 2 1 2 2 2 2 2 1 2 2 2 2 1 1 1 2 1 2 2 1 1 2 1 2 2 1 2 2 1 1 1 2 2 2 1 --feeder_gateway_url http://127.0.0.1:5050  --gateway_url http://127.0.0.1:5050

starknet invoke --address 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801 --function set_random_values --abi ./build/Evaluator_abi.json  --inputs 100 4 2 4 2 2 1 2 4 3 4 4 2 3 1 1 3 4 4 1 1 4 4 2 1 1 2 1 4 3 1 2 3 3 1 4 2 4 3 4 2 4 3 3 3 4 3 1 4 2 3 3 2 1 2 3 2 3 2 2 3 3 3 1 3 3 4 3 4 4 4 3 4 4 4 1 4 4 1 3 1 1 3 2 3 2 2 4 2 3 1 3 1 1 2 2 2 2 4 4 2 2 --feeder_gateway_url http://127.0.0.1:5050  --gateway_url http://127.0.0.1:5050
```

## Finish evaluator setup
```
protostar -p devnet invoke --contract-address 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801 --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --function "finish_setup" --max-fee auto --private-key-path ./.pkey_local
```

## Set evaluator as admin in ERC20
```
protostar -p devnet invoke --contract-address 0x07b12625c751f82ca98838311eae7e77c96f45f6898b9cb1d971522b75a48474 --function "set_teacher" --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --inputs 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801 1 --max-fee auto --private-key-path ./.pkey_local

protostar -p devnet call --contract-address 0x07b12625c751f82ca98838311eae7e77c96f45f6898b9cb1d971522b75a48474 --function "is_teacher_or_exercise" --inputs 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801
```

## Set evaluator as admin in players registry
```
protostar -p devnet invoke --contract-address 0x03bafb663a73882f8d88bad3f922f88f8e2d099d90a5817464577d321aa14bc4 --function "set_exercise_or_admin" --account-address 0x4edae16ce9ba4eecc9eb642633e997d2d39f68e0c87d6d3019086411342721c --inputs 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801 1 --max-fee auto --private-key-path ./.pkey_local

protostar -p devnet call --contract-address 0x03bafb663a73882f8d88bad3f922f88f8e2d099d90a5817464577d321aa14bc4 --function "is_exercise_or_admin" --inputs 0x045a79a4f454c474ee6905b6b79a8c72d99fd593aea34ca2c6d6214249442801
```