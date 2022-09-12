%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IExerciseSolution {
    // Breeding function
    func is_breeder(account: felt) -> (is_approved: felt) {
    }
    func registration_price() -> (price: Uint256) {
    }
    func register_me_as_breeder() -> (is_added: felt) {
    }
    func declare_animal(sex: felt, legs: felt, wings: felt) -> (token_id: Uint256) {
    }
    func get_animal_characteristics(token_id: Uint256) -> (sex: felt, legs: felt, wings: felt) {
    }
    func token_of_owner_by_index(account: felt, index: felt) -> (token_id: Uint256) {
    }
    func declare_dead_animal(token_id: Uint256) {
    }
}
