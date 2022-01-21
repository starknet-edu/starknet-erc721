%lang starknet

from starkware.cairo.common.uint256 import Uint256


@contract_interface
namespace IExerciceSolution:
    # Breeding function
    func is_breeder(account: felt) -> (is_approved: felt):
    end
    # func registration_price() -> (price: felt):
    # end
    func register_me_as_breeder() -> (is_added: felt):
    end
    func declare_animal(sex: felt, legs: felt, wings: felt) -> (token_id: Uint256):
    end
    func get_animal_characteristics(token_id: Uint256) -> (sex: felt, legs: felt, wings: felt) :
    end
    func token_of_owner_by_index(account:felt, index:felt) -> (token_id: Uint256):
    end
    func declare_dead_animal(token_id: Uint256):
    end
    # Selling functions
    # func is_animal_for_sale(token_id: felt) -> (is_for_sale: felt):
    # end
    # func get_animal_price(token_id: felt) -> (price: felt):
    # end
    # func buy_animal(token_id: felt) -> (bought: felt):
    # end
    # func offer_for_sale(token_id: felt) -> (offered: felt):
    # end
    # Reproduction functions
    # func declare_animals_with_parents(sex: felt, legs: felt, wings: felt, parent1: felt, parent2: felt) -> (token_id: felt):
    # end
    # func get_parents(token_id: felt) -> (parent1: felt, parent2: felt):
    # end
    # func can_reproduce(token_id: felt) -> (can_it: felt):
    # end
    # func reproduction_price(token_id: felt) -> (price: felt):
    # end
    # func offer_for_reproduction(token_id: felt, price: felt) -> (offer_created: felt):
    # end
    # func authorized_breeder_to_reproduce(token_id: felt) -> (account: felt):
    # end
    # func pay_to_reproduce(token_id: felt) -> (reproduced: felt):
    # end
end