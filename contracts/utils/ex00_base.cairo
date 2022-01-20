######### Ex 00
## A contract from which other contracts can import functions

%lang starknet

from contracts.token.ERC20.ITDERC20 import ITDERC20
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_sub, uint256_le, uint256_lt, uint256_check
)
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import (get_contract_address, get_caller_address)
#
# Declaring storage vars
# Storage vars are by default not visible through the ABI. They are similar to "private" variables in Solidity
#

@storage_var
func tderc20_address_storage() -> (tderc20_address_storage : felt):
end


@storage_var
func Teacher_accounts(account: felt) -> (balance: felt):
end
	
#
# Declaring getters
# Public variables should be declared explicitely with a getter
#

@view
func tderc20_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (_tderc20_address: felt):
    let (_tderc20_address) = tderc20_address_storage.read()
    return (_tderc20_address)
end

#
# Internal constructor
# This function is used to initialize the contract. It can be called from the constructor
#

func ex_initializer{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        _tderc20_address: felt
    ):
    tderc20_address_storage.write(_tderc20_address)
    let (current_contract_address) = get_contract_address()
    ITDERC20.set_teacher_temp(contract_address=_tderc20_address, account=current_contract_address)
    return ()
end

#
# Internal functions
# These functions can not be called directly by a transaction
# Similar to internal functions in Solidity
#

func distribute_points{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(to: felt, amount: felt):
	
	# Converting felt to uint256. We assume it's a small number 
	# We also add the required number of decimals
	let points_to_credit: Uint256 = Uint256(amount*1000000000000000000, 0)
	# Retrieving contract address from storage
	let (contract_address) = tderc20_address_storage.read()
	# Calling the ERC20 contract to distribute points
	ITDERC20.distribute_points(contract_address=contract_address, to = to, amount = points_to_credit)
	return()
end


func only_teacher{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }():
    let (caller) = get_caller_address()
    let (permission) = Teacher_accounts.read(account=caller)
    assert permission = 1
    return ()
end




@external
func set_teacher{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(account: felt, permission: felt):
    only_teacher()
    Teacher_accounts.write(account, permission)

    return ()
end

@view
func isTeacher{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt) -> (permission: felt):
    let (permission: felt) = Teacher_accounts.read(account)
    return (permission)
end

