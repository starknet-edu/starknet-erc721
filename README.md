# Starknet ERC721 - An Automated Workshop

## Introduction

Today, we are creating your first ERC721 from the ground up on Starknet. The ERC721 token standard stands for non-fungible tokens, also known as NFTs.

The contract interface of the ERC721 that you will need to follow can be found in `src/IERC721.cairo`. Please ensure that all the function names adhere to the IERC721 standard.

Now, let's get our hands dirty!

## What you will learn

- Understanding the basisc of an ERC721 contract
- How to create, implement and deploy an ERC721 contract
- How to interact with Evaluator Contract and validate the exercises

## Disclaimer

​Don’t expect any benefit from using this other than learning some cool stuff about Starknet, the first general-purpose Validity Rollup on the Ethereum mainnet.

## Steps

Your objective is to finish the tutorial, and collect all the points.You will mostly interact with the Evaluator contract which can be found in the table below.

| Contract Code        | Contract on Starkscan                                                                                                                         | Contract on Voyager                                                                                               |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Evaluator            | [Link](https://testnet.starkscan.co/contract/0x02e3ceda622a192488062ed6a453f8a8ebbf472a7b60aaf160cbbc6b485e4155#read-write-contract-sub-read) | [Link](https://goerli.voyager.online/contract/0x02e3ceda622a192488062ed6a453f8a8ebbf472a7b60aaf160cbbc6b485e4155) |
| Points Counter ERC20 | [Link](https://testnet.starkscan.co/contract/0x074b1195731222a7bcbb724d32b93d0c525e173b2c3e9722a2214b101c862801)                              | [Link](https://goerli.voyager.online/contract/0x074b1195731222a7bcbb724d32b93d0c525e173b2c3e9722a2214b101c862801) |

### Counting your points and checking your progress

Your points will be credited to your wallet, though this may take some time. If you want to monitor your points count in real-time, you can also check your balance in a block explorer!

- Go to the ERC20 counter on [Voyager](https://goerli.voyager.online/contract/0x074b1195731222a7bcbb724d32b93d0c525e173b2c3e9722a2214b101c862801) or [Starkscan](https://testnet.starkscan.co/contract/0x074b1195731222a7bcbb724d32b93d0c525e173b2c3e9722a2214b101c862801) in the "read contract" tab.
- Enter your address in the `balanceOf` function.​

Enjoy the workshop! If you have any questions, feel free to contact us on [Discord](https://starknet.io/discord). We are happy to help!

---

## Tasks list

Before we begin, make sure to check out the `IERC721.cairo` which is interface for the ERC721.

### Exercise 1 - Deploying and initilizing your ERC721 (2 points)

First exercise of this part is to create your ERC721 Contract and your constructor function.

1. Create your initial ERC721 contract. You will need the following:
   1. a constructor function that takes the `name` and `symbol` as input and then initializes the contract with those inputs
   2. a `get_name()` to receive the name of the ERC721
   3. a `get_symbol()` to receive the symbol of the ERC721
2. Assign a user slot from the Evaluator contract by calling `assign_user_slot()`
   1. Check the `get_user_slot()` to receive your number
   2. Based on your `user_slot` number, check the `get_info_name()` and `get_info_symbol()` to receive your unique `name` and `symbol`.
   3. use these values to initialize your ERC721
3. Deploy your contract on testnet
   1. make sure you use your given values based on the assigned user slot.
4. Call `submit_exercise()` in the Evaluator to configure the contract you want to be evaluated.
5. Call `ex_01_erc721_init()` to verify your contract and receive points.

### Exercise 2 - Minting a token (2 points)

Here, we will focus on minting your first NFT.

1. Create the `mint()` function that allows you to mint an NFT.
2. Deploy your contract on testnet
3. Call `submit_exercise()` in the Evaluator to configure the contract you want to be evaluated.
4. Call `ex_02_erc721_mint()` to verify your contract and receive points.

### Exercise 3 - Burning a token (2 points)

Here, we will focus on creating the burn function.

1. Create the `burn()` function that allows you to burn an NFT.
2. Deploy your contract on testnet
3. Call `submit_exercise()` in the Evaluator to configure the contract you want to be evaluated.
4. Send a token to the Evaluator contract by using the mint function from your deployed function.
5. Call `ex_03_erc721_burn()` to verify the `burn()` function within your contract and receive points.

### Exercise 4 - Approve function (2 points)

1. Create the `approve()` function
2. Create the `get_approved()` function for the Evaluator to receive the results back
3. Deploy your contract on testnet
4. Call `submit_exercise()` in the Evaluator to configure the contract you want to be evaluated.
5. Call `ex_04_erc721_approve()` to verify your contract and receive points.

### Exercise 5 - Approve all function (2 points)

1. Create the `set_approval_for_all()` function
2. Create the `is_approved_for_all()` function for the Evaluator to receive the results back
3. Deploy your contract on testnet
4. Call `submit_exercise()` in the Evaluator to configure the contract you want to be evaluated.
5. Call `ex_05_erc721_approve_for_all()` to verify your contract and receive points.

### Exercise 6 - Transfering a token (2 points)

Here, we will focus on creating the transfer function.

1. Create the `transfer_from()` function that allows you to transfer the NFT.
2. Deploy your contract on testnet
3. Call `submit_exercise()` in the Evaluator to configure the contract you want to be evaluated.
4. Call `ex_06_erc721_transfer()` to verify your contract and receive points.

---

## Contributing to improve this workshop

This project can be made better and will evolve. Your contributions are welcome! Go to the CONTRIBUTING file for more information on how to setup your environment and contribute to the project.

Here are some things that you can do to help:

Create a branch with a translation to your language
Correct bugs if you find some
Add an explanation in the comments of the exercise if you feel it needs more explanation
Add exercises showcasing your favorite Cairo feature
Add a new tutorial to the series

## Other Automated Workshops

This workshop is the first in a series aimed at teaching how to build on Starknet. Checkout out other workshops in the series:

| Topic                                       | GitHub repo                                                                            |
| ------------------------------------------- | -------------------------------------------------------------------------------------- |
| Learn how to read Cairo code (you are here) | [Cairo 101](https://github.com/starknet-edu/starknet-cairo-101)                        |
| Deploy and customize an ERC721 NFT          | [Starknet ERC721](https://github.com/starknet-edu/starknet-erc721)                     |
| Deploy and customize an ERC20 token         | [Starknet ERC20](https://github.com/starknet-edu/starknet-erc20)                       |
| Build a cross-layer application             | [Starknet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge) |
| Debug your Cairo contracts easily           | [Starknet debug](https://github.com/starknet-edu/starknet-debug)                       |
| Design your own account contract            | [Starknet account abstraction](https://github.com/starknet-edu/starknet-accounts)      |

### Providing feedback & getting help

Once you are done working on this tutorial, your feedback will be greatly appreciated!

<!-- TODO: **Please fill out TBA to let us know what we can do to make it better.** -->

And if you struggle to move forward, do let us know! This workshop is meant to be as accessible as possible; we want to see if it’s not the case.
​
Do you have a question? Join our [Discord server](https://starknet.io/discord), register, and join channel #tutorials-support.

Are you interested in attending online workshops about dev on Starknet? [Subscribe here](https://starknet.substack.com/)
