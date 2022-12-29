## Install Dependencies
```
protostar install OpenZeppelin/cairo-contracts@v0.5.1
```

## Build Contract
```
protostar build --cairo-path ./lib/cairo_contracts/src
```

## Set private key for Testnet
```
touch .pkey_testnet
```

## Deploy TDERC20
```
protostar -p testnet declare ./build/TDERC20.json --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto

protostar -p testnet deploy 0x0015b1abb9eb21e540a1c7550648837d5eec1481fa5ec112c30724f532be553e --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto -i 327360763727160756219953 327360763727160756219953 0 0 158462912486592410958581205749577830428657193233078563605653283152834960921 158462912486592410958581205749577830428657193233078563605653283152834960921

protostar -p testnet call --contract-address 0x0062469b090d7e3c0d27619803b3d1058c91af0301af73a553156e8c889e2d24 --function "name"
```

## Deploy Players Registry
```
protostar -p testnet declare ./build/players_registry.json --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto

protostar -p testnet deploy 0x05db7eb921593a29e41ec904de97b7f69db02a532da935b06a3c8f2678512971 --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto -i 158462912486592410958581205749577830428657193233078563605653283152834960921
```

## Deploy dummy token
```
protostar -p testnet declare ./build/dummy_token.json --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto

protostar -p testnet deploy 0x05fee25dd4509206023b8152c666071b7062be7994cb02774a83e5798a2227bc --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto -i 323287074983686041199982 4478027 100000000000000000000 0 158462912486592410958581205749577830428657193233078563605653283152834960921

protostar -p testnet call --contract-address 0x012e62244d2557718dd5df6e44bd1fc319169d2e076727b9d7e99226e73f0f5f --function "balanceOf" --inputs 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19
```

## Deploy dummy ERC721
```
protostar -p testnet declare ./build/TDERC721_metadata.json --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto

protostar -p testnet deploy 0x006e4142da0432bfd1d0b08ab6ad35540411a08c8ed835ada1247e682b0d687e --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto -i 6072054417219596849 6072054417219596849 158462912486592410958581205749577830428657193233078563605653283152834960921 3 184555836509371486644298270517380613565396767415278678887948391494588524912 181013377130045435659890581909640190867353010602592517226438742938315085926 2194400143691614193218323824727442803459257903 199354445678

protostar -p testnet call --contract-address 0x00ecaefea9409cbd5d902c6bc945e86f0def1eb74530548f07e299711a803832 --function "name"
```

## Deploy Evaluator
```
protostar -p testnet declare ./build/Evaluator.json --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto

protostar -p testnet deploy 0x01de252d12a27e2233a60ee98d9fb41b663546efe08f2337405005466c5a4968 --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --private-key-path ./.pkey_testnet --max-fee auto -i 173638314337651778083972161823343486711186550351742643936992487872179088676 1080537810056067142251673904653510983310498209033309617726697977112022145241 3 1897511498165936872530859039785715365817496773544357673156277720551752070118 534265163387545452242623104234231176704720611209599122898948548362434973535
```

## Set Random Values
```
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount

starknet invoke --address 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9 --function set_random_values --abi ./build/Evaluator_abi.json  --inputs 100 2 7 4 8 7 6 1 7 6 5 4 8 8 5 6 3 8 2 8 6 5 7 3 1 8 6 7 3 6 8 1 7 3 8 2 3 4 5 2 5 7 3 3 4 4 4 5 8 1 7 1 5 7 1 3 2 5 7 8 8 7 1 8 4 1 6 2 1 6 6 4 7 2 1 2 3 5 1 3 8 6 5 5 2 7 8 4 6 4 5 4 6 1 6 4 5 3 5 8 3 0

starknet invoke --address 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9 --function set_random_values --abi ./build/Evaluator_abi.json  --inputs 100 1 1 2 1 1 1 2 2 2 2 1 2 2 2 2 1 2 1 1 1 1 2 2 2 2 2 2 2 2 1 2 1 1 2 1 2 2 1 2 1 1 1 2 2 2 2 2 1 1 2 2 2 2 2 2 1 2 1 1 1 1 2 1 2 2 1 2 1 2 2 2 2 2 1 2 2 2 2 1 1 1 2 1 2 2 1 1 2 1 2 2 1 2 2 1 1 1 2 2 2 1

starknet invoke --address 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9 --function set_random_values --abi ./build/Evaluator_abi.json  --inputs 100 4 2 4 2 2 1 2 4 3 4 4 2 3 1 1 3 4 4 1 1 4 4 2 1 1 2 1 4 3 1 2 3 3 1 4 2 4 3 4 2 4 3 3 3 4 3 1 4 2 3 3 2 1 2 3 2 3 2 2 3 3 3 1 3 3 4 3 4 4 4 3 4 4 4 1 4 4 1 3 1 1 3 2 3 2 2 4 2 3 1 3 1 1 2 2 2 2 4 4 2 2
```

## Finish evaluator setup
```
protostar -p testnet invoke --contract-address 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9 --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --function "finish_setup" --max-fee auto --private-key-path ./.pkey_testnet
```

## Set evaluator as admin in ERC20
```
protostar -p testnet invoke --contract-address 0x0062469b090d7e3c0d27619803b3d1058c91af0301af73a553156e8c889e2d24 --function "set_teacher" --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --inputs 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9 1 --max-fee auto --private-key-path ./.pkey_testnet

protostar -p testnet call --contract-address 0x0062469b090d7e3c0d27619803b3d1058c91af0301af73a553156e8c889e2d24 --function "is_teacher_or_exercise" --inputs 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9
```

## Set evaluator as admin in players registry
```
protostar -p testnet invoke --contract-address 0x0263900ee93e089f6a48ef52d9acc2aa850f5d9a29779495f468fd1e01a6d8d9 --function "set_exercise_or_admin" --account-address 0x0059afd418b4f3c3f18d05ca3ac333d382b3269537204acd314d6e269dad9e19 --inputs 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9 1 --max-fee auto --private-key-path ./.pkey_testnet

protostar -p testnet call --contract-address 0x0263900ee93e089f6a48ef52d9acc2aa850f5d9a29779495f468fd1e01a6d8d9 --function "is_exercise_or_admin" --inputs 0x0764d432fbae633bdc4c565662600b8dee2acdf0b7c7656ef430cbbd580b0fb9
```