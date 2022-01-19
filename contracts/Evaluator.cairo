######### Ex 01
## Using a simple public contract function
# In this exercise, you need to:
# - Use this contract's claim_points() function
# - Your points are credited by the contract

## What you'll learn
# - General smart contract syntax
# - Calling a function

######### General directives and imports
#
#

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

from contracts.utils.ex00_base import (
    tderc20_address,
    distribute_points,
    ex_initializer
)
from contracts.token.IERC721 import IERC721
from starkware.starknet.common.syscalls import (get_contract_address)
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_sub, uint256_le, uint256_lt, uint256_check, uint256_eq
)
#
# Declaring storage vars
# Storage vars are by default not visible through the ABI. They are similar to "private" variables in Solidity
#

@storage_var
func has_been_paired(contract_address: felt) -> (has_been_paired: felt):
end

@storage_var
func student_exercise_solution(student_address: felt) -> (contract_address: felt):
end

@storage_var
func exercises_validation(student_address: felt, exercise_number: felt) -> (has_validated: felt):
end

	# mapping(address => bool) public teachers;
	# ERC20TD TDERC20;

 # 	mapping(address => mapping(uint256 => bool)) public exerciseProgression;
 # 	mapping(address => IexerciseSolution) public studentexerciseSolution;
 	
	# string[20] private randomNames;
	# uint256[20] private randomLegs;
	# uint256[20] private randomSex;
	# bool[20] private randomWings;
	# mapping(address => uint256) public assignedRank;
	# uint public nextValueStoreRank;

######### Constructor
# This function is called when the contract is deployed
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _tderc20_address : felt):
    ex_initializer(_tderc20_address)
    return ()
end

######### External functions
# These functions are callable by other contracts
#


@external
func ex1_test_erc721{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt,salt: felt):
	
	let token_id: Uint256 = Uint256(1,0)
	# Retrieve exercise address
	let (submited_exercise_address) = student_exercise_solution.read(sender_address)

	# Reading evaluator address
	let (evaluator_address) = get_contract_address()
	# Reading who owns token 1 of exercise
	let (token_1_owner_init) = IERC721.ownerOf(contract_address = submited_exercise_address, token_id = token_id)
	# Verifying that token 1 belongs to evaluator
	assert evaluator_address = token_1_owner_init

	# Reading balance of evaluator in exercise
	let (evaluator_init_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Verifying that balance is not 0. Not a perfect check but good enough for this tutorial
	assert_not_zero(evaluator_init_balance.low)

	# Retrieve exercise address again, because of revoked references after calling uint256_eq
	let (submited_exercise_address) = student_exercise_solution.read(sender_address)
	# Reading balance of msg sender in exercise
	let (sender_init_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)

	# Check that token 1 can be transferred back to msg.sender
	IERC721.transferFrom(contract_address = submited_exercise_address, _from=evaluator_address, to=sender_address, token_id = token_id)

	# Reading balance of msg sender after transfer
	let (sender_end_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Reading balance of evaluator after transfer
	let (evaluator_end_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Reading who owns token 1 of exercise
	let (token_1_owner_end) = IERC721.ownerOf(contract_address = submited_exercise_address, token_id = token_id)

	# Verifying that token 1 belongs to sender
	let one_as_uint256: Uint256 = Uint256(1,0)
	assert evaluator_address = sender_address
	let evaluator_expected_balance : Uint256 = uint256_sub(evaluator_init_balance, one_as_uint256)
	let sender_expected_balance : Uint256 = uint256_add(sender_init_balance, one_as_uint256)
	assert evaluator_expected_balance.high = evaluator_end_balance.high
	assert evaluator_expected_balance.low = evaluator_end_balance.low
	assert sender_expected_balance.high = sender_end_balance.high
	assert sender_expected_balance.low = sender_end_balance.low

	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation.read(sender_address, 1)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation.write(sender_address, 1, 1)
		# Sending points
		distribute_points(sender_address, 2)
	end
	return()
end

@external
func submit_exercise{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt, erc721_address: felt, salt: felt):
	# Checking this contract was not used by another group before
	let (has_solution_been_submitted_before) = has_been_paired.read(erc721_address)
	assert has_solution_been_submitted_before = 0

	# Assigning passed ERC721 as student ERC721
	student_exercise_solution.write(sender_address, erc721_address)
	has_been_paired.write(erc721_address, 1)

	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation.read(sender_address, 0)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation.write(sender_address, 0, 1)
		# Sending points
		# setup points
		distribute_points(sender_address, 2)
		# Deploying contract points
		distribute_points(sender_address, 2)

	end

	return()
end


