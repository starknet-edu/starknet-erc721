# ERC721 on StarkNet 

## Introduction
Welcome! This is an automated workshop that will explain how to deploy an ERC721 token on StarkNet and customize it to perform specific functions.
It is aimed at developpers that:
- Understand Cairo syntax
- Understand the ERC721 token standard

​
This workshop is the first in a serie that will cover broad smart contract concepts (writing and deploying ERC20/ERC721, bridging assets, L1 <-> L2 messaging...). 
Interested in helping writing those? [Reach out](https://twitter.com/HenriLieutaud)!
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
Do you have a question? Join our [Discord server](https://discord.gg/YHz7drT3), register and join channel #tutorials-support
​

## How to work on this TD
### Introduction
The TD has two components:
- An [ERC20 token](contracts/token/TDERC20.cairo), ticker TD-ERC721, that is used to keep track of points 
- An [evaluator contract](contracts/Evaluator.cairo), that is able to mint and distribute TD-ERC721 points

Your objective is to gather as many TD-ERC721 points as possible. Please note :
- The 'transfer' function of TD-ERC721 has been disabled to encourage you to finish the TD with only one address
- You can answer the various questions of this workshop with different ERC721 contracts. However, an evaluated address has only one evaluated ERC721 contract at a time. To change the evaluated ERC721 contract associated with your address, call `submit_exercise()`  within the evaluator with that specific address.
- In order to receive points, you will have to do execute code in `Evaluator.cairo` such that the function `distribute_points(sender_address, 2)` is triggered, and distributes n points.
- This repo contains an interface `IExerciceSolution.cairo`. Your ERC721 contract will have to conform to this interface in order to validate the exercice; that is, your contract needs to implement all the functions described in `IExerciceSolution.cairo`. 
- A high level description of what is expected for each exercice is in this readme. A low level description of what is expected can be inferred by reading the code in `Evaluator.cairo`.
- The Evaluator contract sometimes needs to make payments to buy your tokens. Make sure he has enough tokens to do so! If not, you can send ETH directly to the contract.


### Checking your progress
​
#### Counting your points
​
Your points will get credited in Argent X; though this may take some time. If you want to monitor your points count in real time, you can also see your balance in voyager!
​
-   Go to the  [ERC20 counter](https://goerli.voyager.online/contract/0x0555750f277a7abd2d7abf4c16806554bd750eb26d87ce58c6cb13b2158dcbc1#readContract)  in voyager, in the "read contract" tab
-   Enter your address in decimal in the "balanceOf" function
​
#### [](https://github.com/l-henri/starknet-cairo-101/blob/main/README.md#transaction-status)Transaction status
​
You sent a transaction, and it is shown as "undetected" in voyager? This can mean two things:
​
-   Your transaction is pending, and will be included in a block shortly. It will then be visible in voyager.
-   Your transaction was invalid, and will NOT be included in a block (there is no such thing as a failed transaction in StarkNet).
​
You can (and should) check the status of your transaction with the following URL  [https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=](https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=)  , where you can append your transaction hash.
​

### Getting to work
- Clone the repo on your machine
- Setup the environment following [these instructions](https://starknet.io/docs/quickstart.html#quickstart)
- Install [Nile](https://github.com/OpenZeppelin/nile).
- Test that you are able to compile the project
```
nile compile
```

## Points list
### ERC721 basics
- Create an ERC721 token contract. You can use [this implementation](contracts/token/ERC721/)
- Deploy it to the testnet
- Give token #1 to Evaluator contract
- Call `submit_exercise()` in the Evaluator to configure the contract you want evaluated (2 pts)
- Call `ex1_test_erc721()` in the evaluator to receive your points (2 pts) 
- Call `ex2a_get_animal_rank()` to get assigned a random creature to create. 
- Read the expected characteristics of your animal 
- Mint it and give it to the evaluator
- Call `ex2b_test_declare_animal()` to receive points (2 pts)
- Create a function to allow breeder registration. Only allow listed breeders should be able to create animals
- Call `ex3_register_breeder()` to prove your function works (2pts)

### Minting and burning NFTs
- Create a function to allow breeders to declare new animals 
- Call `ex4_declare_new_animal()` to get points (2 pts)
- Create a function to allow breeders to declare dead animals
- Call `ex5_declare_dead_animal()` to get points (2 pts)

### Minting NFTs with Metadata
Not automated yet, soon, but you can still have fun
- Mint an NFT with metadata on contract 0x02b4805efc6815576e9a514cf053febe51a42d0c5c2d1f9ed73da3d25aaf76ad (through voyager, function mint_with_metadata)
- You can use [these assets](assets/)
- Check it on [Oasis](https://testnet.playoasis.xyz/)
- Deploy a new ERC721 contract that supports metadata 
- Each token should have an associated IPFS hash 
- The base token URI is the chosen IPFS gateway
- Your token will be visible on [Oasis](https://testnet.playoasis.xyz/)

## Exercises & Contract addresses 
|Contract code|Contract on voyager|
|---|---|
|[Points counter ERC20](contracts/token/ERC20/TDERC20.cairo)|[0x0266dc612fd2c86f3c059e04be8e25e229dfc039372a5318c71b7c3b8b1b37d0](https://goerli.voyager.online/contract/0x0266dc612fd2c86f3c059e04be8e25e229dfc039372a5318c71b7c3b8b1b37d0)|
|[Evaluator](contracts/Evaluator.cairo)|[0x05cd0c4bd0551f889c245756c03f308ec334f331c9d7297d93141b035d1bb982](https://goerli.voyager.online/contract/0x05cd0c4bd0551f889c245756c03f308ec334f331c9d7297d93141b035d1bb982)|

​
​