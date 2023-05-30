use starknet::ContractAddress;

//###################
// IERC721 INTERFACE
//###################

#[abi]
trait IERC721 {
    fn get_name() -> felt252;
    fn get_symbol() -> felt252;
    fn owner_of(token_id: u256) -> ContractAddress;
    fn balance_of(account: ContractAddress) -> u256;
    fn get_approved(token_id: u256) -> ContractAddress;
    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool;
    fn mint(to: ContractAddress, token_id: u256);
    fn burn(token_id: u256);
    fn approve(to: ContractAddress, token_id: u256);
    fn set_approval_for_all(operator: ContractAddress, approved: bool);
    fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256); 
}

