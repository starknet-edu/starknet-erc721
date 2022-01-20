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


### Getting to work
- Clone the repo on your machine
- Setup the environment following [these instructions](https://starknet.io/docs/quickstart.html#quickstart)
- Install [Nile](https://github.com/OpenZeppelin/nile).
- Test that you are able to compile the project
```
nile compile
```

## Points list
### Setting up
- Create a git repository and share it with the teacher
- Install truffle and create an empty truffle project (2 pts). Create an infura API key to be able to deploy to the Rinkeby testnet
These points will be attributed manually if you do not manage to have your contract interact with the evaluator, or automatically when calling `submitExercice()` for the first time.

### ERC721 basics
- Create an ERC721 token contract wand give token 1 to Evaluator contract
- Deploy it to the Rinkeby testnet
- Call `submitExercice()` in the Evaluator to configure the contract you want evaluated (2 pts)
- Call `ex1_testERC721()` in the evaluator to receive your points (2 pts) 
- Call `ex2a_getAnimalToCreateAttributes()` to get assigned a random creature to create. Mint it and give it to the evaluator
- Call `ex2b_testDeclaredAnimal()` to receive points (2 pts)
- Create a function to allow breeder registration. Only allow listed breeders should be able to create animals
- Call `ex3_testRegisterBreeder()` to prove your function works (2pts)

### Minting and burning NFTs from contracts
- Create a function to allow breeders to declare animals 
- Call `ex4_testDeclareAnimal()` to get points (2 pts)
- Create a function to allow breeders to declare dead animals
- Call `ex5_declareDeadAnimal()` to get points (2 pts)

### Selling and transferring 
- Create a function to offer an animal on sale
- Create a getter for animal sale status and price
- Create a function to buy the animal
- Call `ex6a_auctionAnimal_offer()` to show your code work (1 pt)
- Call `ex6b_auctionAnimal_buy()` to show your code work (2 pt)

### Mix and match
- The following exercices are in `Evaluator2.sol` . 
- Create a function `declareAnimalWithParents()` to declare parents of an animal when creating it
- Create a getter to retrieve parents id `getParents()`
- Call `ex7a_breedAnimalWithParents() ` to get points (1pt)
- Create a function to offer an animal for reproduction, against payment
- Create a getter for animal reproduction status and price
- Call `ex7b_offerAnimalForReproduction()` to get points (1pt)
- Create a function to pay for reproductive rights
- Call `ex7c_payForReproduction()` to get points (1pt)

### Extra points
Extra points if you find bugs / corrections this TD can benefit from, and submit a PR to make it better.  Ideas:
- Adding a way to check the code of a specific contract was only used once (no copying) 
- Publish the code of the Evaluator on Etherscan using the "Verify and publish" functionnality 

## TD addresses
- Points contracts `0x8B7441Cb0449c71B09B96199cCE660635dE49A1D`
- Evaluator `0xa0b9f62A0dC5cCc21cfB71BA70070C3E1C66510E`
- Evaluator2 `0x4f82f7A130821F61931C7675A40fab723b70d1B8`

## Installing


