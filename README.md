# ERC721 on StarkNet

Welcome! This is an automated workshop that will explain how to deploy an ERC721 token on StarkNet and customize it to perform specific functions. The ERC721 standard is described [here](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721).
It is aimed at developers that:

- Understand Cairo syntax
- Understand the ERC721 token standard
​
​

## Introduction

### Disclaimer

​
Don't expect any kind of benefit from using this, other than learning a bunch of cool stuff about StarkNet, the first general purpose validity rollup on the Ethereum Mainnet.
​
StarkNet is still in Alpha. This means that development is ongoing, and the paint is not dry everywhere. Things will get better, and in the meanwhile, we make things work with a bit of duct tape here and there!
​

### How it works

The goal of this tutorial is for you to customize and deploy an ERC721 contract on StarkNet. Your progress will be check by an [evaluator contract](contracts/Evaluator.cairo), deployed on StarkNet, which will grant you points in the form of [ERC20 tokens](contracts/token/ERC20/TDERC20.cairo).

Each exercise will require you to add functionality to your ERC721 token.

For each exercise, you will have to write a new version on your contract, deploy it, and submit it to the evaluator for correction.

### Where am I?

This workshop is the second in a series aimed at teaching how to build on StarkNet. Checkout out the following:

| Topic                                             | GitHub repo                                                                            |
| ------------------------------------------------- | -------------------------------------------------------------------------------------- |
| Learn how to read Cairo code                      | [Cairo 101](https://github.com/starknet-edu/starknet-cairo-101)                        |
| Deploy and customize an ERC721 NFT (you are here) | [StarkNet ERC721](https://github.com/starknet-edu/starknet-erc721)                     |
| Deploy and customize an ERC20 token               | [StarkNet ERC20](https://github.com/starknet-edu/starknet-erc20)                       |
| Build a cross layer application                   | [StarkNet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge) |
| Debug your Cairo contracts easily                 | [StarkNet debug](https://github.com/starknet-edu/starknet-debug)                       |
| Design your own account contract                  | [StarkNet account abstraction](https://github.com/starknet-edu/starknet-accounts)      |

### Providing feedback & getting help

Once you are done working on this tutorial, your feedback would be greatly appreciated!

**Please fill out [this form](https://forms.reform.app/starkware/untitled-form-4/kaes2e) to let us know what we can do to make it better.**

​
And if you struggle to move forward, do let us know! This workshop is meant to be as accessible as possible; we want to know if it's not the case.

​
Do you have a question? Join our [Discord server](https://starknet.io/discord), register, and join channel #tutorials-support
​
Are you interested in following online workshops about learning how to dev on StarkNet? [Subscribe here](http://eepurl.com/hFnpQ5)

### Contributing

This project can be made better and will evolve as StarkNet matures. Your contributions are welcome! Here are things that you can do to help:

- Create a branch with a translation to your language
- Correct bugs if you find some
- Add an explanation in the comments of the exercise if you feel it needs more explanation
- Add exercises showcasing your favorite Cairo feature

​

## Getting ready to work

### Step 1 - Clone the repo

```bash
git clone https://github.com/starknet-edu/starknet-erc721
cd starknet-erc721
```

### Step 2 - Set up your environment

There are two ways to set up your environment on StarkNet: a local installation, or using a docker container

- For Mac and Linux users, we recommend either
- For windows users we recommend docker

For a production setup instructions we wrote [this article](https://medium.com/starknet-edu/the-ultimate-starknet-dev-environment-716724aef4a7).

#### Option A - Set up a local python environment

- Set up the environment following [these instructions](https://starknet.io/docs/quickstart.html#quickstart)
- Install [OpenZeppelin's cairo contracts](https://github.com/OpenZeppelin/cairo-contracts).

```bash
pip install openzeppelin-cairo-contracts
```

#### Option B - Use a dockerized environment

- Linux and macos

for mac m1:

```bash
alias cairo='docker run --rm -v "$PWD":"$PWD" -w "$PWD" shardlabs/cairo-cli:latest-arm'
```

for amd processors

```bash
alias cairo='docker run --rm -v "$PWD":"$PWD" -w "$PWD" shardlabs/cairo-cli:latest'
```

- Windows

```bash
docker run --rm -it -v ${pwd}:/work --workdir /work shardlabs/cairo-cli:latest
```

### Step 3 -Test that you are able to compile the project

```bash
starknet-compile contracts/Evaluator.cairo
```

​
​

## Working on the tutorial

### Workflow

To do this tutorial you will have to interact with the [`Evaluator.cairo`](contracts/Evaluator.cairo) contract. To validate an exercise you will have to

- Read the evaluator code to figure out what is expected of your contract
- Customize your contract's code
- Deploy it to StarkNet's testnet. This is done using the CLI.
- Register your exercise for correction, using the `submit_exercise` function on the evaluator. This is done using Voyager.
- Call the relevant function on the evaluator contract to get your exercise corrected and receive your points. This is done using Voyager.

For example to solve the first exercise the workflow would be the following:

`deploy a smart contract that answers ex1` &rarr; `call submit_exercise on the evaluator providing your smart contract address` &rarr; `call ex1_test_erc721 on the evaluator contract`

**Your objective is to gather as many ERC721-101 points as possible.** Please note :

- The 'transfer' function of ERC721-101 has been disabled to encourage you to finish the tutorial with only one address
- In order to receive points, the evaluator has to reach the calls to the  `distribute_point` function.
- This repo contains an interface `IExerciseSolution.cairo`. Your ERC721 contract will have to conform to this interface in order to validate some exercises; that is, your contract needs to implement all the functions described in `IExerciseSolution.cairo`.
- **We really recommend that your read the [`Evaluator.cairo`](contracts/Evaluator.cairo) contract in order to fully understand what's expected for each exercise**. A high level description of what is expected for each exercise is provided in this readme.
- The Evaluator contract sometimes needs to make payments to buy your tokens. Make sure he has enough dummy tokens to do so! If not, you should get dummy tokens from the dummy tokens contract and send them to the evaluator

### Contracts code and addresses

| Contract code                                                        | Contract on voyager                                                                                                                                                           |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Points counter ERC20](contracts/token/ERC20/TDERC20.cairo)          | [0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707](https://goerli.voyager.online/contract/0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707) |
| [Evaluator](contracts/Evaluator.cairo)                               | [0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15](https://goerli.voyager.online/contract/0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15) |
| [Dummy ERC20 token](contracts/token/ERC20/dummy_token.cairo)         | [0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3](https://goerli.voyager.online/contract/0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3) |
| [Dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo) | [0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21](https://goerli.voyager.online/contract/0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21)   |

​
​

## Tasks list

Today we are creating an animal registry! Animals are bred by breeders. They can be born, die, reproduce, be sold. You will implement these features little by little.

### Exercise 1 - Deploying an ERC721

- Create an ERC721 token contract. You can use [this implementation](https://github.com/OpenZeppelin/cairo-contracts/blob/release-v0.5.0/src/openzeppelin/token/erc721/presets/ERC721MintableBurnable.cairo) as a base
- Deploy it to the testnet (check the constructor for the needed arguments. Also note that the arguments should be decimals.)

```bash
starknet-compile contracts/ERC721/ERC721.cairo --output artifacts/ERC721.json
starknet deploy --contract artifacts/ERC721.json --inputs arg1 arg2 arg3 --network alpha-goerli 
```

- Give token #1 to Evaluator contract
- Call [`submit_exercise()`](contracts/Evaluator.cairo#L601) in the Evaluator to configure the contract you want evaluated (4 pts)
- Call [`ex1_test_erc721()`](contracts/Evaluator.cairo#L146) in the evaluator to receive your points (2 pts)

### Exercise 2 - Creating token attributes

- Call [`ex2a_get_animal_rank()`](contracts/Evaluator.cairo#L245) to get assigned a random creature to create.
- Read the expected characteristics of your animal from the Evaluator
- Create the tools necessary to record animals characteristics in your contract and enable the evaluator contract to retrieve them trough `get_animal_characteristics` function on your contract ([check this](contracts/IExerciseSolution.cairo))
- Deploy your new contract
- Mint the animal with the desired characteristics and give it to the evaluator
- Call [`submit_exercise()`](contracts/Evaluator.cairo#L601) in the Evaluator to configure the contract you want evaluated
- Call [`ex2b_test_declare_animal()`](contracts/Evaluator.cairo#L258) to receive points (2 pts)

### Exercise 3 - Minting NFTs

- Create a function to allow breeders to mint new animals with the specified characteristics
- Deploy your new contract
- Call [`submit_exercise()`](contracts/Evaluator.cairo#L601) in the Evaluator to configure the contract you want evaluated
- Call [`ex3_declare_new_animal()`](contracts/Evaluator.cairo#L272) to get points (2 pts)

### Exercise 4 - Burning NFTs

- Create a function to allow breeders to declare dead animals (burn the NFT)
- Deploy your new contract
- Call [`submit_exercise()`](contracts/Evaluator.cairo#L601) in the Evaluator to configure the contract you want evaluated
- Call [`ex4_declare_dead_animal()`](contracts/Evaluator.cairo#L323) to get points (2 pts)

### Exercise 5 - Adding permissions and payments

- Use [dummy token faucet](contracts/token/ERC20/dummy_token.cairo) to get dummy tokens
- Use [`ex5a_i_have_dtk()`](contracts/Evaluator.cairo#L406) to show you managed to use the faucet (2 pts)
- Create a function to allow breeder registration.
- This function should charge the registrant for a fee, paid in dummy tokens ([check `registration_price`](contracts/IExerciseSolution.cairo))
- Add permissions. Only allow listed breeders should be able to create animals
- Deploy your new contract
- Call [`submit_exercise()`](contracts/Evaluator.cairo#L601) in the Evaluator to configure the contract you want evaluated
- Call [`ex5b_register_breeder()`](contracts/Evaluator.cairo#L440) to prove your function works. If needed, send dummy tokens first to the evaluator (2pts)

### Exercise 6 - Claiming an NFT

- Mint a NFT with metadata on [this dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo) , usable [here](https://goerli.voyager.online/contract/0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21)
- Check it on [Aspect](https://testnet.aspect.co/)
- Claim points on [`ex6_claim_metadata_token`](contracts/Evaluator.cairo#L523) (2 pts)

### Exercise 7 - Adding metadata

- Create a new ERC721 contract that supports metadata. You can use [this contract](contracts/token/ERC721/ERC721_metadata.cairo) as a base
- The base token URI is the chosen IPFS gateway
- You can upload your NFTs directly on [this website](https://www.pinata.cloud/)
- Your tokens should be visible on [Aspect](https://testnet.aspect.co/) once minted!
- Deploy your new contract
- Call [`submit_exercise()`](contracts/Evaluator.cairo#L601) in the Evaluator to configure the contract you want evaluated
- Claim points on [`ex7_add_metadata`](contracts/Evaluator.cairo#L557) (2 pts)

​

## Annex - Useful tools

### Converting data to and from decimal

To convert data to felt use the [`utils.py`](utils.py) script
To open Python in interactive mode after running script

  ```bash
  python -i utils.py
  ```

  ```python
  >>> str_to_felt('ERC20-101')
  1278752977803006783537
  ```

### Checking your progress & counting your points

​
Your points will get credited in your wallet; though this may take some time. If you want to monitor your points count in real time, you can also see your balance in voyager!
​

- Go to the  [ERC20 counter](https://goerli.voyager.online/contract/0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707#readContract)  in voyager, in the "read contract" tab
- Enter your address in decimal in the "balanceOf" function

You can also check your overall progress [here](https://starknet-tutorials.vercel.app)
​

### Transaction status

​
You sent a transaction, and it is shown as "undetected" in voyager? This can mean two things:
​

- Your transaction is pending, and will be included in a block shortly. It will then be visible in voyager.
- Your transaction was invalid, and will NOT be included in a block (there is no such thing as a failed transaction in StarkNet).
​
You can (and should) check the status of your transaction with the following URL  [https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=](https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=)  , where you can append your transaction hash.
​

​
