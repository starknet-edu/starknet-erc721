# ERC721 on StarkNet

## Introduction

Welcome! This is an automated workshop that will explain how to deploy an ERC721 token on StarkNet and customize it to perform specific functions. The ERC721 standard is described [here](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721).
It is aimed at developers that:

- Understand Cairo syntax
- Understand the ERC721 token standard

​
This workshop is the second in a series that will cover broad smart contract concepts (writing and deploying ERC20/ERC721, bridging assets, L1 <-> L2 messaging...).
You can find the first tutorial [here](https://github.com/l-henri/starknet-cairo-101)
Interested in helping writing those? [Reach out](https://twitter.com/HenriLieutaud)!

## Table of contents

- [ERC721 on StarkNet](#erc721-on-starknet)
  - [Introduction](#introduction)
  - [Table of contents](#table-of-contents)
    - [Disclaimer](#disclaimer)
    - [Providing feedback](#providing-feedback)
  - [How to work on this tutorial](#how-to-work-on-this-tutorial)
    - [Before you start](#before-you-start)
    - [Workflow](#workflow)
    - [Checking your progress](#checking-your-progress)
      - [Counting your points](#counting-your-points)
      - [Transaction status](#transaction-status)
      - [Install nile](#install-nile)
        - [With pip](#with-pip)
        - [With docker](#with-docker)
    - [Getting to work](#getting-to-work)
  - [Contract addresses](#contract-addresses)
  - [Points list](#points-list)
    - [ERC721 basics](#erc721-basics)
      - [Exercise 1](#exercise-1)
      - [Exercise 2](#exercise-2)
    - [Minting and burning NFTs](#minting-and-burning-nfts)
      - [Exercise 3](#exercise-3)
      - [Exercicse 4](#exercicse-4)
    - [Adding permissions and payments](#adding-permissions-and-payments)
      - [Exercise 5](#exercise-5)
    - [Minting NFTs with Metadata](#minting-nfts-with-metadata)
      - [Exercise 6](#exercise-6)
      - [Exercise 7](#exercise-7)
​

### Disclaimer

​
Don't expect any kind of benefit from using this, other than learning a bunch of cool stuff about StarkNet, the first general purpose validity rollup on the Ethereum Mainnnet.
​
StarkNet is still in Alpha. This means that development is ongoing, and the paint is not dry everywhere. Things will get better, and in the meanwhile, we make things work with a bit of duct tape here and there!
​

### Providing feedback

Once you are done working on this tutorial, your feedback would be greatly appreciated!
**Please fill [this form](https://forms.reform.app/starkware/untitled-form-4/kaes2e) to let us know what we can do to make it better.**
​
And if you struggle to move forward, do let us know! This workshop is meant to be as accessible as possible; we want to know if it's not the case.
​
Do you have a question? Join our [Discord server](https://discord.gg/B7PevJGCCw), register and join channel #tutorials-support
​

## How to work on this tutorial

### Before you start

The TD has three components:

- An [ERC20 token](contracts/token/ERC20/TDERC20.cairo), ticker ERC721-101, that is used to keep track of points
- An [evaluator contract](contracts/Evaluator.cairo), that is able to mint and distribute ERC721-101 points
- A second [ERC20 token](contracts/token/ERC20/dummy_token.cairo), ticker DTK, that is used to make fake payments

### Workflow

To do this tutorial you will have to interact with the `Evaluator.cairo` contract. To do an exercise you will have to use the `submit_exercise` function to tell the evaluator the address of the evaluated contract. Once it's done you can call the evaluator for it to correct the desired exericse.
For example to solve the first exercise the workflow would be the following:

`deploy a smart contract that answers ex1` &rarr; `call submit_exercise on the evaluator providing your smart contract address` &rarr; `call ex1_test_erc721 on the evaluator contract`

Your objective is to gather as many ERC721-101 points as possible. Please note :

- The 'transfer' function of ERC721-101 has been disabled to encourage you to finish the tutorial with only one address
- In order to receive points, you will have to reach the calls to the  `distribute_point` function.
- This repo contains an interface `IExerciceSolution.cairo`. Your ERC721 contract will have to conform to this interface in order to validate the exercise; that is, your contract needs to implement all the functions described in `IExerciceSolution.cairo`.
- **We really recommend that your read the [`Evaluator.cairo`](contracts/Evaluator.cairo) contract in order to fully understand what's expected for each exercise**. A high level description of what is expected for each exercise is provided in this readme.
- The Evaluator contract sometimes needs to make payments to buy your tokens. Make sure he has enough dummy tokens to do so! If not, you should get dummy tokens from the dummy tokens contract and send them to the evaluator

### Checking your progress

#### Counting your points

​
Your points will get credited in your wallet; though this may take some time. If you want to monitor your points count in real time, you can also see your balance in voyager!
​

- Go to the  [ERC20 counter](https://goerli.voyager.online/contract/0x0272abeb08a98ce2024b96dc522fdcf71e91bd333b228ad62ca664920881bc52#readContract)  in voyager, in the "read contract" tab
- Enter your address in decimal in the "balanceOf" function

You can also check your overall progress [here](https://starknet-tutorials.vercel.app)
​

#### Transaction status

​
You sent a transaction, and it is shown as "undetected" in voyager? This can mean two things:
​

- Your transaction is pending, and will be included in a block shortly. It will then be visible in voyager.
- Your transaction was invalid, and will NOT be included in a block (there is no such thing as a failed transaction in StarkNet).
​
You can (and should) check the status of your transaction with the following URL  [https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=](https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=)  , where you can append your transaction hash.
​

#### Install nile

##### With pip

- Set up the environment following [these instructions](https://starknet.io/docs/quickstart.html#quickstart)
- Install [Nile](https://github.com/OpenZeppelin/nile).

##### With docker

- Linux and macos

for mac m1:

```bash
alias nile='docker run --rm -v "$PWD":"$PWD" -w "$PWD" lucaslvy/nile:0.8.0-arm'
```

for amd processors

```bash
alias nile='docker run --rm -v "$PWD":"$PWD" -w "$PWD" lucaslvy/nile:0.8.0-x86'
```

- Windows

```bash
docker run --rm -it -v ${pwd}:/work --workdir /work lucaslvy/0.8.0-x86
```

### Getting to work

- Clone the repo on your machine
- Test that you are able to compile the project

```bash
nile compile
```

- To convert data to felt use the [`utils.py`](utils.py) script

## Contract addresses

| Contract code                                                        | Contract on voyager                                                                                                                                                             |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Points counter ERC20](contracts/token/ERC20/TDERC20.cairo)          | [0x0272abeb08a98ce2024b96dc522fdcf71e91bd333b228ad62ca664920881bc52](https://goerli.voyager.online/contract/0x0272abeb08a98ce2024b96dc522fdcf71e91bd333b228ad62ca664920881bc52) |
| [Evaluator](contracts/Evaluator.cairo)                               | [0x03b56add608787daa56932f92c6afbeb50efdd78d63610d9a904aae351b6de73](https://goerli.voyager.online/contract/0x03b56add608787daa56932f92c6afbeb50efdd78d63610d9a904aae351b6de73) |
| [Dummy ERC20 token](contracts/token/ERC20/dummy_token.cairo)         | [0x07ff0a898530b169c5fe6fed9b397a7bbd402973ce2f543965f99d6d4a4c17b8](https://goerli.voyager.online/contract/0x07ff0a898530b169c5fe6fed9b397a7bbd402973ce2f543965f99d6d4a4c17b8) |
| [Dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo) | [0x02e24bd7683c01cb2e4e48148e254f2a0d44ee526cff3c703d6031a685f1700d](https://goerli.voyager.online/contract/0x02e24bd7683c01cb2e4e48148e254f2a0d44ee526cff3c703d6031a685f1700d) |

## Points list

Today we are creating an animal registry! Animals are bred by breeders. They can be born, die, reproduce, be sold. You will implement these features little by little.

### ERC721 basics

#### Exercise 1

- Create an ERC721 token contract. You can use [this implementation](contracts/token/ERC721/ERC721.cairo) as a base
- Deploy it to the testnet (check the constructor for the needed arguments. Also note that the arguments should be decimals.)

```bash
nile compile contracts/token/ERC721/ERC721.cairo
nile deploy ERC721 arg1 arg2 arg3 --network goerli 
```

- Give token #1 to Evaluator contract
- Call `submit_exercise()` in the Evaluator to configure the contract you want evaluated (2 pts)
- Call `ex1_test_erc721()` in the evaluator to receive your points (2 pts)

#### Exercise 2

- Call `ex2a_get_animal_rank()` to get assigned a random creature to create.
- Read the expected characteristics of your animal from the Evaluator
- Create the tools necessary to record animals characteristics in your contract and enable the evaluator contract to retrieve them trough `get_animal_characteristics` function on your contract ([check this](contracts/IExerciceSolution.cairo))
- Mint the animal with the desired characteristics and give it to the evaluator
- Call `ex2b_test_declare_animal()` to receive points (2 pts)

### Minting and burning NFTs

#### Exercise 3

- Create a function to allow breeders to mint new animals with the specified characteristics
- Call `ex3_declare_new_animal()` to get points (2 pts)

#### Exercicse 4

- Create a function to allow breeders to declare dead animals (burn the NFT)
- Call `ex4_declare_dead_animal()` to get points (2 pts)

### Adding permissions and payments

#### Exercise 5

- Use [dummy token faucet](contracts/token/ERC20/dummy_token.cairo) to get dummy tokens
- Use `ex5a_i_have_dtk()` to show you managed to use the faucet (2 pts)
- Create a function to allow breeder registration.
- This function should charge the registrant for a fee, paid in dummy tokens ([check `registration_price`](contracts/IExerciceSolution.cairo))
- Add permissions. Only allow listed breeders should be able to create animals
- Call `ex5b_register_breeder()` to prove your function works. If needed, send dummy tokens first to the evaluator (2pts)

### Minting NFTs with Metadata

#### Exercise 6

- Mint a NFT with metadata on [this dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo) , usable [here](https://goerli.voyager.online/contract/0x02e24bd7683c01cb2e4e48148e254f2a0d44ee526cff3c703d6031a685f1700d)
- Check it on [Oasis](https://testnet.playoasis.xyz/)
- Claim points on `ex6_claim_metadata_token` (2 pts)

#### Exercise 7

- Create a new ERC721 contract that supports metadata. You can use [this contract](contracts/token/ERC721/ERC721_metadata.cairo) as a base
- The base token URI is the chosen IPFS gateway
- You can upload your NFTs directly on [this website](https://www.pinata.cloud/)
- Your tokens should be visible on [Oasis](https://testnet.playoasis.xyz/) once minted!
- Claim points on `ex7_add_metadata` (2 pts)

​
​
