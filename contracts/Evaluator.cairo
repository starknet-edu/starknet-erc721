# ######## ERC 721 evaluator
# Soundtrack https://www.youtube.com/watch?v=iuWa5wh8lG0

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.math import assert_not_zero

from contracts.utils.ex00_base import (
    tderc20_address,
    distribute_points,
    ex_initializer,
    has_validated_exercise,
    validate_exercice,
)

from contracts.utils.String import String_get, String_set
from contracts.token.ERC721.IERC721 import IERC721
from contracts.token.ERC721.IERC721_metadata import IERC721_metadata
from contracts.IExerciceSolution import IExerciceSolution
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
)
from contracts.token.ERC20.ITDERC20 import ITDERC20
from contracts.token.ERC20.IERC20 import IERC20

#
# Declaring storage vars
# Storage vars are by default not visible through the ABI. They are similar to "private" variables in Solidity
#

@storage_var
func has_been_paired(contract_address : felt) -> (has_been_paired : felt):
end

@storage_var
func player_exercise_solution_storage(player_address : felt) -> (contract_address : felt):
end

@storage_var
func assigned_rank_storage(player_address : felt) -> (rank : felt):
end

@storage_var
func next_rank_storage() -> (next_rank : felt):
end

@storage_var
func max_rank_storage() -> (max_rank : felt):
end

@storage_var
func random_attributes_storage(column : felt, rank : felt) -> (value : felt):
end

@storage_var
func was_initialized() -> (was_initialized : felt):
end

@storage_var
func dummy_token_address_storage() -> (dummy_token_address_storage : felt):
end

@storage_var
func dummy_metadata_erc721_storage() -> (dummy_metadata_erc721_storage : felt):
end

#
# Declaring getters
# Public variables should be declared explicitly with a getter
#

@view
func player_exercise_solution{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address : felt
) -> (contract_address : felt):
    let (contract_address) = player_exercise_solution_storage.read(player_address)
    return (contract_address)
end

@view
func assigned_rank{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address : felt
) -> (rank : felt):
    let (rank) = assigned_rank_storage.read(player_address)
    return (rank)
end

@view
func assigned_legs_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address : felt
) -> (legs : felt):
    let (rank) = assigned_rank(player_address)
    let (legs) = random_attributes_storage.read(0, rank)
    return (legs)
end

@view
func assigned_sex_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address : felt
) -> (sex : felt):
    let (rank) = assigned_rank(player_address)
    let (sex) = random_attributes_storage.read(1, rank)
    return (sex)
end

@view
func assigned_wings_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address : felt
) -> (wings : felt):
    let (rank) = assigned_rank(player_address)
    let (wings) = random_attributes_storage.read(2, rank)
    return (wings)
end

# ######## Constructor
# This function is called when the contract is deployed
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _tderc20_address : felt,
    _players_registry : felt,
    _workshop_id : felt,
    dummy_metadata_erc721_address : felt,
    _dummy_token_address : felt,
):
    ex_initializer(_tderc20_address, _players_registry, _workshop_id)
    dummy_token_address_storage.write(_dummy_token_address)
    dummy_metadata_erc721_storage.write(dummy_metadata_erc721_address)
    # Hard coded value for now
    max_rank_storage.write(100)
    return ()
end

# ######## External functions
# These functions are callable by other contracts
#

@external
func ex1_test_erc721{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Allocating locals. Make your code easier to write and read by avoiding some revoked references
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()
    let token_id : Uint256 = Uint256(1, 0)
    # Retrieve exercise address
    let (submited_exercise_address) = player_exercise_solution_storage.read(sender_address)

    # Reading evaluator address
    let (evaluator_address) = get_contract_address()
    # Reading who owns token 1 of exercise
    let (token_1_owner_init) = IERC721.ownerOf(
        contract_address=submited_exercise_address, token_id=token_id
    )
    # Verifying that token 1 belongs to evaluator
    assert evaluator_address = token_1_owner_init

    # Reading balance of evaluator in exercise
    let (evaluator_init_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=evaluator_address
    )
    # Reading balance of msg sender in exercise
    let (sender_init_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=sender_address
    )

    # Instanciating a zero in uint format
    let zero_as_uint256 : Uint256 = Uint256(0, 0)
    let (is_equal) = uint256_eq(evaluator_init_balance, zero_as_uint256)
    assert is_equal = 0

    # Check that token 1 can be transferred back to msg.sender
    IERC721.transferFrom(
        contract_address=submited_exercise_address,
        _from=evaluator_address,
        to=sender_address,
        token_id=token_id,
    )

    # Reading balance of msg sender after transfer
    let (sender_end_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=sender_address
    )
    # Reading balance of evaluator after transfer
    let (evaluator_end_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=evaluator_address
    )
    # Reading who owns token 1 of exercise
    let (token_1_owner_end) = IERC721.ownerOf(
        contract_address=submited_exercise_address, token_id=token_id
    )
    # Verifying that token 1 belongs to sender
    assert token_1_owner_end = sender_address
    # I need value 1 in the uint format to be able to substract it, and add it, to compare balances
    let one_as_uint256 : Uint256 = Uint256(1, 0)
    # Store expected balance in a variable, since I can't use everything on a single line
    let evaluator_expected_balance : Uint256 = uint256_sub(evaluator_init_balance, one_as_uint256)
    let (sender_expected_balance, _) = uint256_add(sender_init_balance, one_as_uint256)
    # Verifying that balances where updated correctly
    let (is_sender_balance_equal_to_expected) = uint256_eq(
        sender_expected_balance, sender_end_balance
    )
    assert is_sender_balance_equal_to_expected = 1
    let (is_evaluator_balance_equal_to_expected) = uint256_eq(
        evaluator_expected_balance, evaluator_end_balance
    )
    assert is_evaluator_balance_equal_to_expected = 1

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 1)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 1)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

# Call this function to get assigned a rank, and the associate characteristics expected from your animal
@external
func ex2a_get_animal_rank{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    # Reading caller address
    let (sender_address) = get_caller_address()

    ex2a_get_animal_rank_internal(sender_address)

    return ()
end

# Show that you properly declared your animal
@external
func ex2b_test_declare_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token_id : Uint256
):
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()

    ex2b_test_declare_animal_internal(sender_address, token_id)

    return ()
end

# Create a function that allows any breeder to call your contract and declare a new animal
@external
func ex3_declare_new_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Retrieve exercise address
    let (submited_exercise_address) = player_exercise_solution_storage.read(sender_address)
    # Reading evaluator address
    let (evaluator_address) = get_contract_address()
    # Reading balance of evaluator in exercise
    let (evaluator_init_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=evaluator_address
    )
    # Requesting new attributes
    ex2a_get_animal_rank_internal(sender_address)

    # Retrieve expected characteristics
    let (expected_sex) = assigned_sex_number(sender_address)
    let (expected_legs) = assigned_legs_number(sender_address)
    let (expected_wings) = assigned_wings_number(sender_address)

    # Declaring a new animal with the desired parameters
    let (created_token) = IExerciceSolution.declare_animal(
        contract_address=submited_exercise_address,
        sex=expected_sex,
        legs=expected_legs,
        wings=expected_wings,
    )

    # Checking that the animal was declared correctly. We basically reuse ex2 lol
    # If it wasn't done correctly, this should fail
    ex2b_test_declare_animal_internal(sender_address, created_token)

    # Ok so if I got until here then... nothing failed. I get points
    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 3)

    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 3)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

# Sometimes, animals die. Your contract should implement that.
@external
func ex4_declare_dead_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Retrieve exercise address
    let (submited_exercise_address) = player_exercise_solution_storage.read(sender_address)
    # Reading evaluator address
    let (evaluator_address) = get_contract_address()
    # Getting initial token balance. Must be at least 1
    let (evaluator_init_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=evaluator_address
    )

    # Getting an animal id of Evaluator. tokenOfOwnerByIndex should return the list of NFTs owned by and address
    let (token_id) = IExerciceSolution.token_of_owner_by_index(
        contract_address=submited_exercise_address, account=evaluator_address, index=0
    )

    # Declaring it as dead
    IExerciceSolution.declare_dead_animal(
        contract_address=submited_exercise_address, token_id=token_id
    )

    # Checking end balance
    let (evaluator_end_balance) = IERC721.balanceOf(
        contract_address=submited_exercise_address, owner=evaluator_address
    )
    # I need value 1 in the uint format to be able to substract it, and add it, to compare balances
    let one_as_uint256 : Uint256 = Uint256(1, 0)
    # Store expected balance in a variable, since I can't use everything on a single line
    let evaluator_expected_balance : Uint256 = uint256_sub(evaluator_init_balance, one_as_uint256)
    # Verifying that balances where updated correctly
    let (is_evaluator_balance_equal_to_expected) = uint256_eq(
        evaluator_expected_balance, evaluator_end_balance
    )
    assert is_evaluator_balance_equal_to_expected = 1

    # Check that properties are deleted
    # Reading animal characteristic in player solution
    let (read_sex, read_legs, read_wings) = IExerciceSolution.get_animal_characteristics(
        contract_address=submited_exercise_address, token_id=token_id
    )
    # Checking characteristics are correct
    assert read_sex = 0
    assert read_legs = 0
    assert read_wings = 0
    # TODO Testing killing another person's animal. The caller has to hold an animal
    # Requires try / catch, or something smarter. I'll think about it.

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 4)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 4)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

# For ex5 you need ERC20 tokens. Go get them
@external
func ex5a_i_have_dtk{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Reading sender balance in dummy token
    let (dummy_token_address) = dummy_token_address_storage.read()
    let (dummy_token_init_balance) = IERC20.balanceOf(
        contract_address=dummy_token_address, account=sender_address
    )

    # Verifying it's not 0
    # Instanciating a zero in uint format
    let zero_as_uint256 : Uint256 = Uint256(0, 0)
    let (is_equal) = uint256_eq(dummy_token_init_balance, zero_as_uint256)
    assert is_equal = 0

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 51)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 51)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

# Allow breeder to pay for registration as a breeder
@external
func ex5b_register_breeder{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Retrieve exercise address
    let (submited_exercise_address) = player_exercise_solution_storage.read(sender_address)
    # Get evaluator address
    let (evaluator_address) = get_contract_address()
    # Is evaluator currently a breeder?
    let (is_evaluator_breeder_init) = IExerciceSolution.is_breeder(
        contract_address=submited_exercise_address, account=evaluator_address
    )
    assert is_evaluator_breeder_init = 0
    # TODO test that evaluator can not yet declare an animal (requires try/catch)

    # Reading registration price. Registration is payable in dummy token
    let (registration_price) = IExerciceSolution.registration_price(
        contract_address=submited_exercise_address
    )
    # Reading evaluator balance in dummy token
    let (dummy_token_address) = dummy_token_address_storage.read()
    let (dummy_token_init_balance) = IERC20.balanceOf(
        contract_address=dummy_token_address, account=evaluator_address
    )
    # Approve the exercice for spending my dummy tokens
    IERC20.approve(
        contract_address=dummy_token_address,
        spender=submited_exercise_address,
        amount=registration_price,
    )

    # Require breeder permission.
    IExerciceSolution.register_me_as_breeder(contract_address=submited_exercise_address)

    # Check that I am indeed a breeder
    let (is_evaluator_breeder_end) = IExerciceSolution.is_breeder(
        contract_address=submited_exercise_address, account=evaluator_address
    )
    assert is_evaluator_breeder_end = 1

    # Check that my balance has been updated
    let (dummy_token_end_balance) = IERC20.balanceOf(
        contract_address=dummy_token_address, account=evaluator_address
    )
    # Store expected balance in a variable, since I can't use everything on a single line
    let evaluator_expected_balance : Uint256 = uint256_sub(
        dummy_token_init_balance, registration_price
    )
    # Verifying that balances where updated correctly
    let (is_evaluator_balance_equal_to_expected) = uint256_eq(
        evaluator_expected_balance, dummy_token_end_balance
    )
    assert is_evaluator_balance_equal_to_expected = 1

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 52)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 52)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

@external
func ex6_claim_metadata_token{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token_id : Uint256
):
    # Allocating locals. Make your code easier to write and read by avoiding some revoked references
    alloc_locals
    # Retrieve dummy token address
    let (dummy_metadata_erc721_address) = dummy_metadata_erc721_storage.read()
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Reading who owns token token_id
    let (token_owner) = IERC721.ownerOf(
        contract_address=dummy_metadata_erc721_address, token_id=token_id
    )
    # Verifying that token 1 belongs to evaluator
    assert sender_address = token_owner

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 6)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 6)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

# Check that ERC721 has implemented metadata queries
@external
func ex7_add_metadata{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Retrieve exercise address
    let (submited_exercise_address) = player_exercise_solution_storage.read(sender_address)
    # Get evaluator address
    let (evaluator_address) = get_contract_address()
    # Retrieve dummy token address
    let (dummy_metadata_erc721_address) = dummy_metadata_erc721_storage.read()
    # Reading metadata URI for token 1 on both contracts. For these to show up in Oasis, they should be equal
    let token_id = Uint256(0, 1)
    let (metadata_player_len, metadata_player) = IERC721_metadata.tokenURI(
        contract_address=submited_exercise_address, token_id=token_id
    )
    let (metadata_dummy_len, metadata_dummy) = IERC721_metadata.tokenURI(
        contract_address=dummy_metadata_erc721_address, token_id=token_id
    )
    # Verifying they are equal
    assert metadata_dummy_len = metadata_player_len
    ex7_check_arrays_are_equal(metadata_dummy_len, metadata_dummy, metadata_player)
    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 7)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 7)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

@external
func submit_exercise{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    erc721_address : felt
):
    # Reading caller address
    let (sender_address) = get_caller_address()
    # Checking this contract was not used by another group before
    let (has_solution_been_submitted_before) = has_been_paired.read(erc721_address)
    assert has_solution_been_submitted_before = 0

    # Assigning passed ERC721 as player ERC721
    player_exercise_solution_storage.write(sender_address, erc721_address)
    has_been_paired.write(erc721_address, 1)

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 0)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...

    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 0)
        # Sending points
        # setup points
        distribute_points(sender_address, 2)
        # Deploying contract points
        distribute_points(sender_address, 2)
    end

    return ()
end

#
# Internal functions
#

func ex2a_get_animal_rank_internal{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(sender_address : felt):
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
    return ()
end

func ex2b_test_declare_animal_internal{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(sender_address : felt, token_id : Uint256):
    alloc_locals
    # Retrieve expected characteristics
    let (expected_sex) = assigned_sex_number(sender_address)
    let (expected_legs) = assigned_legs_number(sender_address)
    let (expected_wings) = assigned_wings_number(sender_address)

    # Retrieve exercise address
    let (submited_exercise_address) = player_exercise_solution_storage.read(sender_address)
    # Get current contract address
    let (evaluator_address) = get_contract_address()
    # Reading who owns token 1 of exercise
    let (token_owner) = IERC721.ownerOf(
        contract_address=submited_exercise_address, token_id=token_id
    )
    # Verifying that token 1 belongs to evaluator
    assert evaluator_address = token_owner

    # Reading animal characteristic in player solution
    let (read_sex, read_legs, read_wings) = IExerciceSolution.get_animal_characteristics(
        contract_address=submited_exercise_address, token_id=token_id
    )
    # Checking characteristics are correct
    assert read_sex = expected_sex
    assert read_legs = expected_legs
    assert read_wings = expected_wings

    # Checking if player has validated this exercise before
    let (has_validated) = has_validated_exercise(sender_address, 2)
    # This is necessary because of revoked references. Don't be scared, they won't stay around for too long...
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    if has_validated == 0:
        # player has validated
        validate_exercice(sender_address, 2)
        # Sending points
        distribute_points(sender_address, 2)
    end
    return ()
end

func ex7_check_arrays_are_equal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    arrays_len : felt, array_1 : felt*, array_2 : felt*
):
    if arrays_len == 0:
        return ()
    end
    ex7_check_arrays_are_equal(arrays_len=arrays_len - 1, array_1=array_1 + 1, array_2=array_2 + 1)
    assert [array_1] = [array_2]
    return ()
end
#
# External functions - Administration
# Only admins can call these. You don't need to understand them to finish the exercice.
#

@external
func set_random_values{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    values_len : felt, values : felt*, column : felt
):
    # Check if the random values were already initialized
    let (was_initialized_read) = was_initialized.read()
    assert was_initialized_read = 0

    # Check that we fill max_ranK_storage cells
    let (max_rank) = max_rank_storage.read()
    assert values_len = max_rank

    # Storing passed values in the store
    set_a_random_value(values_len, values, column)

    return ()
end

@external
func finish_setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Check if the random values were already initialized
    let (was_initialized_read) = was_initialized.read()
    assert was_initialized_read = 0

    # Mark that value store was initialized
    was_initialized.write(1)
    return ()
end

func set_a_random_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    values_len : felt, values : felt*, column : felt
):
    if values_len == 0:
        # Start with sum=0.
        return ()
    end

    set_a_random_value(values_len=values_len - 1, values=values + 1, column=column)
    random_attributes_storage.write(column, values_len - 1, [values])

    return ()
end
