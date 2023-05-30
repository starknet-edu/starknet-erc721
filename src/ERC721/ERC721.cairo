////////////////////////////////
// ERC721Base
// A Base ERC721 contract to implement ERC721 standarded methods
// such as `transfer`, `transfer_from`, `mint`, 'burn', etc.
////////////////////////////////

#[contract]
#[derive(Copy, Drop)]
mod ERC721Base {
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use starknet::ContractAddressZeroable;
    use starknet::Felt252TryIntoContractAddress;
    use starknet::ContractAddressIntoFelt252;
    use traits::TryInto;
    use traits::Into;
    use option::OptionTrait;

    ////////////////////////////////
    // Struct
    ////////////////////////////////

    struct Storage {
        name: felt252,
        symbol: felt252,
        owners: LegacyMap::<u256, ContractAddress>,
        balances: LegacyMap::<ContractAddress, u256>,
        token_approvals: LegacyMap::<u256, ContractAddress>,
        operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
    }

    ////////////////////////////////
    // View Functions
    ////////////////////////////////

    fn get_name() -> felt252 {
        name::read()
    }

    fn get_symbol() -> felt252 {
        symbol::read()
    }

    fn owner_of(token_id: u256) -> ContractAddress {
        let owner = owners::read(token_id);
        assert(!owner.is_zero(), 'ERC721: invalid token ID');
        owner
    }

    fn balance_of(account: ContractAddress) -> u256 {
        assert(!account.is_zero(), 'ERC721: address zero');
        balances::read(account)
    }

    fn get_approved(token_id: u256) -> ContractAddress {
        assert(_exists(token_id), 'ERC721: invalid token ID');
        token_approvals::read(token_id)
    }

    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool {
        operator_approvals::read((owner, operator))
    }

    ////////////////////////////////
    // Internal Constructor
    ////////////////////////////////
    fn initializer(
        name_: felt252, symbol_: felt252
    ) {
        name::write(name_);
        symbol::write(symbol_);
    }

    ////////////////////////////////
    // Internal FUNCTIONS
    ////////////////////////////////

    fn approve(to: ContractAddress, token_id: u256) {
        let owner = _owner_of(token_id);

        assert(to.into() != owner.into(), 'Approval to current owner');

        assert(get_caller_address().into() == owner.into() | is_approved_for_all(owner, get_caller_address()), 'Not token owner');
        _approve(to, token_id);
    }

    fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256) {
        assert(_is_approved_or_owner(from, token_id), 'Caller is not owner or approved');
        _transfer(from, to, token_id);
    }

    fn set_approval_for_all(operator: ContractAddress, approved: bool) {
        let caller = get_caller_address();
        assert(!caller.is_zero() & !operator.is_zero(), 'ERC721: Caller/Operator is zero');

        assert(caller.into() != operator.into(), 'ERC721: approve to caller');
        operator_approvals::write((caller, operator), approved);
        // ApprovalForAll(caller, operator, approved);
    }

    fn _mint(to: ContractAddress, token_id: u256) {
        assert(!to.is_zero(), 'ERC721: mint to 0');
        assert(!_exists(token_id), 'ERC721: already minted');

        balances::write(to, balances::read(to) + 1.into());
        owners::write(token_id, to);

        // Transfer(contract_address_const::<0>(), to, token_id);

    }

    fn _burn(token_id: u256) {

        let owner = owner_of(token_id);

        token_approvals::write(token_id, contract_address_const::<0>());

        balances::write(owner, balances::read(owner) - 1.into());
        owners::write(token_id, contract_address_const::<0>());

        // Transfer(owner, contract_address_const::<0>(), token_id);
    }

    fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {
        assert(from.into() == owner_of(token_id).into(), 'Transfer from incorrect owner');
        assert(!to.is_zero(), 'ERC721: transfer to 0');

        token_approvals::write(token_id, contract_address_const::<0>());

        balances::write(from, balances::read(from) - 1.into());
        balances::write(to, balances::read(to) + 1.into());

        owners::write(token_id, to);

        // Transfer(from, to, token_id);

    }

    fn _approve(to: ContractAddress, token_id: u256) {
        token_approvals::write(token_id, to);
        // Approval(owner_of(token_id), to, token_id);
    }

    fn _is_approved_or_owner(spender: ContractAddress, token_id: u256) -> bool {
        let owner = owners::read(token_id);

        spender.into() == owner.into() 
            | is_approved_for_all(owner, spender) 
            | get_approved(token_id).into() == spender.into()
    }
    
    fn _exists(token_id: u256) -> bool {
        !_owner_of(token_id).is_zero()
    }

    fn _owner_of(token_id: u256) -> ContractAddress {
        owners::read(token_id)
    }



}
