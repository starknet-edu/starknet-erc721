// ######## ERC 721 evaluator
// Soundtrack https://www.youtube.com/watch?v=iuWa5wh8lG0

#[contract]
#[derive(Copy, Drop)]
mod Evaluator{

    ////////////////////////////////
    // Core Library Imports
    ////////////////////////////////
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use starknet::ContractAddress;
    use starknet::contract_address::ContractAddressZeroable;
    use array::ArrayTrait;
    use option::OptionTrait;
    use zeroable::Zeroable;
    use traits::TryInto;
    use traits::Into;
    use integer::u256;
    use integer::u256_from_felt252;


    ////////////////////////////////
    // Internal Imports
    ////////////////////////////////
    use starknet_erc721::utils::ex00_base::Ex00Base::distribute_points;
    use starknet_erc721::utils::ex00_base::Ex00Base::validate_exercise;
    use starknet_erc721::utils::ex00_base::Ex00Base::ex_initializer;
    use starknet_erc721::utils::ex00_base::Ex00Base::update_class_hash_by_admin;
    use starknet_erc721::utils::helper;
    use starknet_erc721::utils::helper::check_boolean;
    use starknet_erc721::ERC721::IERC721::IERC721Dispatcher;
    use starknet_erc721::ERC721::IERC721::IERC721DispatcherTrait;

    ////////////////////////////////
    // Storage
    ////////////////////////////////
    struct Storage{
        user_slots: LegacyMap::<ContractAddress, u128>,
        names_mapped: LegacyMap::<u128, felt252>,
        symbols_mapped: LegacyMap::<u128, felt252>,
        was_initialized: LegacyMap::<u8, bool>,
        next_slot: u128,
        player_exercise_solution_storage: LegacyMap::<ContractAddress, ContractAddress>,
        has_been_paired: LegacyMap::<ContractAddress, bool>,
    }

    ////////////////////////////////
    // CONSTANTS
    ////////////////////////////////
    const USER_SLOT_LIMIT: u128 = 99_u128; 


    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    #[constructor]
    fn constructor(
        _tderc20_address: ContractAddress, _players_registry: ContractAddress, _workshop_id: u128, _exercise_id: u128
    ) {
        ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id);
    }

    ////////////////////////////////
    // View Functions
    ////////////////////////////////
    #[view]
    fn get_user_slot(account: ContractAddress) -> u128 {
        user_slots::read(account)
    }

    #[view]
    fn player_exercise_solution(player_address: ContractAddress) -> ContractAddress {
        player_exercise_solution_storage::read(player_address)
    }

    #[view]
    fn get_info_name(user_slot: u128) -> felt252 {
        names_mapped::read(user_slot)
    }

    #[view]
    fn get_info_symbol(user_slot: u128) -> felt252 {
        symbols_mapped::read(user_slot)
    }

    ////////////////////////////////
    // External Functions
    ////////////////////////////////
    #[external]
    fn ex_01_erc721_init(){

        // Run the verification steps before continuing
        let submitted_exercise_address:ContractAddress = verify();

        // Retrieve caller address
        let sender_address = get_caller_address();

        // Retrieve name and symbol from the submitted exercise
        let name = IERC721Dispatcher{contract_address: submitted_exercise_address}.get_name();
        let symbol = IERC721Dispatcher{contract_address: submitted_exercise_address}.get_symbol();

        // Retrieve assigned user slot for the caller address
        let _user_slot = user_slots::read(sender_address);

        // Retrieve assigned variable based on the user slot
        let assigned_name = get_info_name(_user_slot);
        let assigned_symbol = get_info_symbol(_user_slot);

        // Checking if the name/symbol are correctly initialized
        assert(name == assigned_name, 'NAME_INCORRECT');
        assert(symbol == assigned_symbol, 'SYMBOL_INCORRECT');

        // Checking if the user has validated the exercise before
        validate_exercise(sender_address);
        // Sending points to the address specified as parameter
        distribute_points(sender_address, 2_u128);
    }

    #[external]
    fn ex_02_erc721_mint(token_id: u256){
        // Run the verification steps before continuing
        let submitted_exercise_address:ContractAddress = verify();

        // Retrieve caller address
        let sender_address = get_caller_address();

        // Retrieve the evaluator address
        let _contract_address = get_contract_address();

        // minting token_id
        IERC721Dispatcher{contract_address: submitted_exercise_address}.mint(_contract_address, token_id);

        // Retrieve the owner of token_id
        let check_owner_of = IERC721Dispatcher{contract_address: submitted_exercise_address}.owner_of(token_id);

        // Checking if owner of the token_id is the evaluator
        assert(check_owner_of == _contract_address, 'NOT_THE_OWNER');

        // Checking if the user has validated the exercise before
        validate_exercise(sender_address);
        // Sending points to the address specified as parameter
        distribute_points(sender_address, 2_u128);
    }

    #[external]
    fn ex_03_erc721_burn(token_id: u256){
        
        // Run the verification steps before continuing
        let submitted_exercise_address:ContractAddress = verify();

        // Retrieve caller address
        let sender_address = get_caller_address();

        // Get the evaluator address
        let _contract_address = get_contract_address();

        // Retrieve balance before burn
        let balance_c1 = IERC721Dispatcher{contract_address: submitted_exercise_address}.balance_of(_contract_address);

        // check if burn method works
        IERC721Dispatcher{contract_address: submitted_exercise_address}.burn(token_id);

        // Retrieve balance after burn
        let balance_c2 = IERC721Dispatcher{contract_address: submitted_exercise_address}.balance_of(_contract_address);

        // Checking if owner of the token_id is the evaluator
        assert(balance_c2 == balance_c1 - u256_from_felt252(1), 'BALANCE_INCORRECT');

        // Checking if the user has validated the exercise before
        validate_exercise(sender_address);
        // Sending points to the address specified as parameter
        distribute_points(sender_address, 2_u128);

    }

    #[external]
    fn ex_04_erc721_approve(token_id: u256){
        // Run the verification steps before continuing
        let submitted_exercise_address:ContractAddress = verify();

        // Retrieve caller address
        let sender_address = get_caller_address();

        // call the approve function
        IERC721Dispatcher{contract_address: submitted_exercise_address}.approve(sender_address, token_id);

        // retrieving result
        let approved_address = IERC721Dispatcher{contract_address: submitted_exercise_address}.get_approved(token_id);

        // checking if approve function is correctly executed
        assert(approved_address == sender_address, 'ADDRESS_NOT_APPROVED');
        
        // Checking if the user has validated the exercise before
        validate_exercise(sender_address);
        // Sending points to the address specified as parameter
        distribute_points(sender_address, 2_u128);

    }

    #[external]
    fn ex_05_erc721_approve_for_all(){
        // Run the verification steps before continuing
        let submitted_exercise_address:ContractAddress = verify();

        // Retrieve caller address
        let sender_address = get_caller_address();

        // Get the evaluator address
        let _contract_address = get_contract_address();

        // call the approve for all function
        IERC721Dispatcher{contract_address: submitted_exercise_address}.set_approval_for_all(sender_address, true);

        // retrieving result
        let is_approved = IERC721Dispatcher{contract_address: submitted_exercise_address}.is_approved_for_all(_contract_address, sender_address);

        assert(check_boolean(is_approved) == check_boolean(true), 'NOT_APPROVED_FOR_ALL');
        
        // Checking if the user has validated the exercise before
        validate_exercise(sender_address);
        // Sending points to the address specified as parameter
        distribute_points(sender_address, 2_u128);     
    }

    #[external]
    fn ex_06_erc721_transfer(token_id: u256){

        // Run the verification steps before continuing
        let submitted_exercise_address:ContractAddress = verify();

        // Retrieve caller address
        let sender_address = get_caller_address();

        // Get the evaluator address
        let _contract_address = get_contract_address();

        // Retrieve balance and owner before transfer
        let balance_c1 = IERC721Dispatcher{contract_address: submitted_exercise_address}.balance_of(sender_address);
        let owner_c1 = IERC721Dispatcher{contract_address: submitted_exercise_address}.owner_of(token_id);

        // approve for transfer
        IERC721Dispatcher{contract_address: submitted_exercise_address}.approve(sender_address, token_id);

        // approve for transfer
        IERC721Dispatcher{contract_address: submitted_exercise_address}.transfer_from(_contract_address, sender_address, token_id);

        // Retrieve balance and owner after transfer
        let balance_c2 = IERC721Dispatcher{contract_address: submitted_exercise_address}.balance_of(sender_address);
        let owner_c2 = IERC721Dispatcher{contract_address: submitted_exercise_address}.owner_of(token_id);

        // Checks
        assert(balance_c2 == balance_c1 + u256_from_felt252(1), 'WRONG_BALANCE');
        assert(owner_c1 != owner_c2, 'OWNER_IS_THE_SAME');
        assert(owner_c2 == sender_address, 'OWNER_WRONG');

        // Checking if the user has validated the exercise before
        validate_exercise(sender_address);
        // Sending points to the address specified as parameter
        distribute_points(sender_address, 2_u128);

    }

    #[external]
    fn submit_exercise(exercise_address: ContractAddress){
        // Retrieve caller address
        let sender_address = get_caller_address();

        // Check if exercise has been submited before.
        assert(check_boolean(has_been_paired::read(exercise_address)) != check_boolean(true), 'SOLUTION_SUBMITED_ALREADY');

        // Store exercise address
        player_exercise_solution_storage::write(sender_address, exercise_address);
        has_been_paired::write(exercise_address, true);

    }

    // This function is used to assign a slot to a user and to update the next slot
    #[external]
    fn assign_user_slot() {
        // Retrieve caller address
        let sender_address: ContractAddress = get_caller_address();

        let _next_slot = next_slot::read(); 

        if _next_slot == USER_SLOT_LIMIT {
            next_slot::write(0_u128);
        }

        user_slots::write(sender_address, next_slot::read() + 1_u128);
        next_slot::write(next_slot::read() + 1_u128);

    }

    ////////////////////////////////
    // External functions - Administration
    // Only admins can call these. You don't need to understand them to finish the exercise.
    ////////////////////////////////
    #[external]
    fn update_class_hash(class_hash: felt252) {
        update_class_hash_by_admin(class_hash);
    }

    #[external]
    fn set_random_names(values: Array::<felt252>) {
        // Check if the random values were already initialized
        let was_initialized_read = was_initialized::read(0_u8);
        assert(check_boolean(was_initialized_read) != check_boolean(true), 'NOT_INITIALISED');

        let mut idx: u128 = 0_u128;
        set_a_random_name(idx, values);

        // Mark that names store was initialized
        was_initialized::write(0_u8, true);
    }

    #[external]
    fn set_random_symbols(values: Array::<felt252>) {
        // Check if the random values were already initialized
        let was_initialized_read = was_initialized::read(1_u8);
        assert(check_boolean(was_initialized_read) != check_boolean(true), 'NOT_INITIALISED');

        let mut idx: u128 = 0_u128;
        set_a_random_symbol(idx, values);

        // Mark that symbols store was initialized
        was_initialized::write(1_u8, true);
    }

    fn set_a_random_name(mut idx: u128, mut values: Array::<felt252>) {
        helper::check_gas();
        if !values.is_empty() {
            names_mapped::write(idx, values.pop_front().unwrap());
            idx = idx + 1_u128;
            set_a_random_name(idx, values);
        }
    }

    fn set_a_random_symbol(mut idx: u128, mut values: Array::<felt252>) {
        helper::check_gas();
        if !values.is_empty() {
            symbols_mapped::write(idx, values.pop_front().unwrap());
            idx = idx + 1_u128;
            set_a_random_symbol(idx, values);
        }
    }

    fn verify() -> ContractAddress {
        // Retrieve caller address
        let sender_address = get_caller_address();

        // Retrieve exercise address
        let submitted_exercise_address  = player_exercise_solution_storage::read(sender_address);
        
        // Reading the slot assigned to the caller address in the mapping user_slots.
        // The value was assigned when assign_user_slot() was called by the user (see below) and is stored in the mapping user_slots
        let user_slot = user_slots::read(sender_address);
        // Checking that the user has a slot assigned to they (i.e. that he called assign_user_slot() before)
        assert(user_slot != 0_u128, 'ASSIGN_USER_SLOT_FIRST');

        // Check if solution has been submitted
        assert(!submitted_exercise_address.is_zero(), 'SOLUTION_NOT_SUBMITTED');

        // returning the submitted exercise 
        submitted_exercise_address
    }

}
