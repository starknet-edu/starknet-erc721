######### ERC 721 evaluator
# Soundtrack https://www.youtube.com/watch?v=iuWa5wh8lG0

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
from contracts.IExerciceSolution import IExerciceSolution
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
func student_exercise_solution_storage(student_address: felt) -> (contract_address: felt):
end

@storage_var
func exercises_validation_storage(student_address: felt, exercise_number: felt) -> (has_validated: felt):
end

@storage_var
func assigned_rank_storage(student_address: felt) -> (rank: felt):
end

@storage_var
func next_rank_storage() -> (next_rank: felt):
end	

@storage_var
func max_rank_storage() -> (max_rank: felt):
end	

@storage_var
func random_attributes_storage(column: felt, rank: felt) -> (legs: felt):
end	

@storage_var
func was_initialized() -> (was_initialized: felt):
end
#
# Declaring getters
# Public variables should be declared explicitly with a getter
#

@view
func student_exercise_solution{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(student_address: felt) -> (contract_address: felt):
    let (contract_address) = student_exercise_solution_storage.read(student_address)
    return (contract_address)
end

@view
func exercises_validation{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(student_address: felt, exercise_number: felt) -> (has_validated: felt):
    let (has_validated) = exercises_validation_storage.read(student_address, exercise_number)
    return (has_validated)
end

@view
func assigned_rank{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(student_address: felt) -> (rank: felt):
    let (rank) = assigned_rank_storage.read(student_address)
    return (rank)
end

@view
func assigned_legs_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(student_address: felt) -> (legs: felt):
	let (rank) = assigned_rank(student_address)
    let (legs) = random_attributes_storage.read(0, rank)
    return (legs)
end

@view
func assigned_sex_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(student_address: felt) -> (sex: felt):
	let (rank) = assigned_rank(student_address)
    let (sex) = random_attributes_storage.read(1, rank)
    return (sex)
end

@view
func assigned_wings_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(student_address: felt) -> (wings: felt):
	let (rank) = assigned_rank(student_address)
    let (wings) = random_attributes_storage.read(2, rank)
    return (wings)
end

######### Constructor
# This function is called when the contract is deployed
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _tderc20_address : felt):
    ex_initializer(_tderc20_address)
    # Hard coded value for now
    max_rank_storage.write(100)
    return ()
end

######### External functions
# These functions are callable by other contracts
#


@external
func ex1_test_erc721{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt,salt: felt):
	# Allocating locals. Make your code easier to write and read by avoiding some revoked references
	alloc_locals
	let token_id: Uint256 = Uint256(1,0)
	# Retrieve exercise address
	let (submited_exercise_address) = student_exercise_solution_storage.read(sender_address)

	# Reading evaluator address
	let (evaluator_address) = get_contract_address()
	# Reading who owns token 1 of exercise
	let (token_1_owner_init) = IERC721.ownerOf(contract_address = submited_exercise_address, token_id = token_id)
	# Verifying that token 1 belongs to evaluator
	assert evaluator_address = token_1_owner_init

	# Reading balance of evaluator in exercise
	let (evaluator_init_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Reading balance of msg sender in exercise
	let (sender_init_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)

	# Instanciating a zero in uint format
	let zero_as_uint256: Uint256 = Uint256(0,0)
	let (is_equal) = uint256_eq(evaluator_init_balance, zero_as_uint256)
	assert is_equal = 0

	# Check that token 1 can be transferred back to msg.sender
	IERC721.transferFrom(contract_address = submited_exercise_address, _from=evaluator_address, to=sender_address, token_id = token_id)

	# Reading balance of msg sender after transfer
	let (sender_end_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Reading balance of evaluator after transfer
	let (evaluator_end_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Reading who owns token 1 of exercise
	let (token_1_owner_end) = IERC721.ownerOf(contract_address = submited_exercise_address, token_id = token_id)
	# Verifying that token 1 belongs to sender
	assert token_1_owner_end = sender_address
	# I need value 1 in the uint format to be able to substract it, and add it, to compare balances
	let one_as_uint256: Uint256 = Uint256(1,0)
	# Store expected balance in a variable, since I can't use everything on a single line
	let evaluator_expected_balance : Uint256 = uint256_sub(evaluator_init_balance, one_as_uint256)
	let sender_expected_balance : Uint256 = uint256_add(sender_init_balance, one_as_uint256)
	# Verifying that balances where updated correctly
	let (is_sender_balance_equal_to_expected) = uint256_eq(sender_expected_balance, sender_end_balance) 
	assert is_sender_balance_equal_to_expected = 1
	let (is_evaluator_balance_equal_to_expected) = uint256_eq(evaluator_expected_balance, evaluator_end_balance)
	assert is_evaluator_balance_equal_to_expected = 1

	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation_storage.read(sender_address, 1)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation_storage.write(sender_address, 1, 1)
		# Sending points
		distribute_points(sender_address, 2)
	end
	return()
end

@external
func ex2a_get_animal_rank{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt, salt: felt):
	alloc_locals
	# Reading next available slot
	let (next_rank) = next_rank_storage.read()
	# Assigning to user
	assigned_rank_storage.write(sender_address, next_rank)

	let new_next_rank = next_rank + 1
	let (max_rank) = max_rank_storage.read()

	# Checking if we reach max_rank
	if new_next_rank == max_rank:
		next_rank_storage.write(0)
	else:
		next_rank_storage.write(new_next_rank)
	end
	return()
end

@external
func ex2b_test_declare_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt, token_id: Uint256, salt: felt):
	alloc_locals

	# Retrieve expected characteristics
	let (expected_sex) = assigned_sex_number(sender_address)
	let (expected_wings) = assigned_wings_number(sender_address)
	let (expected_legs) = assigned_legs_number(sender_address)

	# Retrieve exercise address
	let (submited_exercise_address) = student_exercise_solution_storage.read(sender_address)
	# Get current contract address
	let (evaluator_address) = get_contract_address()
	# Reading who owns token 1 of exercise
	let (token_owner) = IERC721.ownerOf(contract_address = submited_exercise_address, token_id = token_id)
	# Verifying that token 1 belongs to evaluator
	assert evaluator_address = token_owner

	# Reading animal characteristic in student solution
	let (read_sex, read_wings, read_legs) = IExerciceSolution.get_animal_characteristics(contract_address = submited_exercise_address, token_id=token_id)
	# Checking characteristics are correct
	assert read_sex = expected_sex
	assert read_wings = expected_wings
	assert read_legs = expected_legs

	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation_storage.read(sender_address, 2)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation_storage.write(sender_address, 2, 1)
		# Sending points
		distribute_points(sender_address, 2)
	end
	return()
end

@external
func ex3_register_breeder{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt, salt: felt):
	alloc_locals
	# Retrieve exercise address
	let (submited_exercise_address) = student_exercise_solution_storage.read(sender_address)
	# Get evaluator address
	let (evaluator_address) = get_contract_address()
	# Is evaluator currently a breeder?
	let (is_evaluator_breeder_init) = IExerciceSolution.is_breeder(contract_address = submited_exercise_address, account = sender_address)
	assert is_evaluator_breeder_init = 0
	# TODO test that evaluator can not yet declare an animal (requires try/catch)
	
	# Require breeder permission. 
	IExerciceSolution.register_me_as_breeder(contract_address = submited_exercise_address)

	# Check that I am indeed a breeder
	let (is_evaluator_breeder_end) = IExerciceSolution.is_breeder(contract_address = submited_exercise_address, account = sender_address)
	assert is_evaluator_breeder_init = 1

	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation_storage.read(sender_address, 3)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation_storage.write(sender_address, 3, 1)
		# Sending points
		distribute_points(sender_address, 2)
	end
	return()
end

@external
func ex4_declare_new_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt, salt: felt):
	alloc_locals
	# Retrieve exercise address
	let (submited_exercise_address) = student_exercise_solution_storage.read(sender_address)
	# Reading evaluator address
	let (evaluator_address) = get_contract_address()
	# Reading balance of evaluator in exercise
	let (evaluator_init_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# Requesting new attributes. Note that this will not be possible anymore once transactions are sent through contract account directly, without sender_address. 
	# But I'll correct it later, I am in a hurry now
	ex2a_get_animal_rank(sender_address, 0)

	# Retrieve expected characteristics
	let (expected_sex) = assigned_sex_number(sender_address)
	let (expected_wings) = assigned_wings_number(sender_address)
	let (expected_legs) = assigned_legs_number(sender_address)

	# Declaring a new animal with the desired parameters
	let (created_token) = IExerciceSolution.declare_animal(contract_address = submited_exercise_address, sex=expected_sex, legs=expected_legs, wings=expected_wings)

	# Checking that the animal was declared correctly. We basically reuse ex2 lol
	# If it wasn't done correctly, this should fail
	# Same, I'll have to modify this later on. Internal functions will be useful.
	ex2b_test_declare_animal(sender_address,created_token,0)

	# Ok so if I got until here then... nothing failed. I get points
	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation_storage.read(sender_address, 4)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation_storage.write(sender_address, 4, 1)
		# Sending points
		distribute_points(sender_address, 2)
	end
	return()
end

@external
func ex5_declare_dead_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(sender_address: felt, salt: felt):
	alloc_locals
	# Retrieve exercise address
	let (submited_exercise_address) = student_exercise_solution_storage.read(sender_address)
	# Reading evaluator address
	let (evaluator_address) = get_contract_address()
	# Getting initial token balance. Must be at least 1
	let (evaluator_init_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)

	# Getting an animal id of Evaluator. tokenOfOwnerByIndex should return the list of NFTs owned by and address
	let (token_id) = IExerciceSolution.token_of_owner_by_index(contract_address = submited_exercise_address, account=evaluator_address, index=0)

	# Declaring it as dead
	IExerciceSolution.declare_dead_animal(contract_address = submited_exercise_address, token_id=token_id)

	# Checking end balance
	let (evaluator_end_balance) = IERC721.balanceOf(contract_address = submited_exercise_address, owner = evaluator_address)
	# I need value 1 in the uint format to be able to substract it, and add it, to compare balances
	let one_as_uint256: Uint256 = Uint256(1,0)
	# Store expected balance in a variable, since I can't use everything on a single line
	let evaluator_expected_balance : Uint256 = uint256_sub(evaluator_init_balance, one_as_uint256)
	# Verifying that balances where updated correctly
	let (is_evaluator_balance_equal_to_expected) = uint256_eq(evaluator_expected_balance, evaluator_end_balance)
	assert is_evaluator_balance_equal_to_expected = 1

	# Check that properties are deleted 
	# Reading animal characteristic in student solution
	let (read_sex, read_wings, read_legs) = IExerciceSolution.get_animal_characteristics(contract_address = submited_exercise_address, token_id=token_id)
	# Checking characteristics are correct
	assert read_sex = 0
	assert read_wings = 0
	assert read_legs = 0
	# TODO Testing killing another person's animal. The caller has to hold an animal
	# Requires try / catch, or something smarter. I'll think about it.
	
	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation_storage.read(sender_address, 5)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation_storage.write(sender_address, 5, 1)
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
	student_exercise_solution_storage.write(sender_address, erc721_address)
	has_been_paired.write(erc721_address, 1)

	# Checking if student has validated this exercise before
	let (has_validated) = exercises_validation_storage.read(sender_address, 0)
	# This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

	tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

	if has_validated == 0:
		# Student has validated
		exercises_validation_storage.write(sender_address, 0, 1)
		# Sending points
		# setup points
		distribute_points(sender_address, 2)
		# Deploying contract points
		distribute_points(sender_address, 2)

	end

	return()
end



#
# External functions - Administration
# Only admins can call these. You don't need to understand them to finish the exercice.
#

@external
func set_random_values{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(values_len: felt, values: felt*, column: felt):

    # Check if the random values were already initialized
    let (was_initialized_read) = was_initialized.read()
    assert was_initialized_read = 0

    # Check that we fill max_ranK_storage cells
    let (max_rank) = max_rank_storage.read()
    assert values_len = max_rank
    
    # Storing passed values in the store
    set_a_random_value(values_len, values, column)

    return()
end

@external
func finish_setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():

    # Check if the random values were already initialized
    let (was_initialized_read) = was_initialized.read()
    assert was_initialized_read = 0
   
    # Mark that value store was initialized
    was_initialized.write(1)
    return()
end

func set_a_random_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(values_len: felt, values: felt*, column: felt):
    if values_len == 0:
        # Start with sum=0.
        return ()
    end


    set_a_random_value(values_len=values_len - 1, values=values + 1, column=column)
    random_attributes_storage.write(column, values_len-1, [values])

    return ()
end
