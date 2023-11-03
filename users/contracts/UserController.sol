pragma solidity >=0.8.0;
import "./User.sol";
contract UserController {
    mapping (address => address) wallet_to_user;
    address reputation_system;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function get_user_contract_address(address user) public view returns(address) {
        return wallet_to_user[user];
    }

    function get_user_reputation_score(address user) public view returns(int256) {
        return User(user).get_reputation_score();
    }

    function get_user_tickets(address user) public view returns(address[] memory ) {
        return User(user).get_tickets();
    }

    function get_user_events(address user) public view returns(address[] memory) {
        return User(user).get_events();
    }

    function add_user_ticket(address user, address ticket) public {
        User(user).add_ticket(ticket);
    }

    function add_user_event(address user, address event1) public {
        User(user).add_event(event1);
    }

    function delete_user_ticket(address user, address ticket) public {
        User(user).delete_ticket(ticket);
    }

    function delete_user_event(address user, address event1) public {
        User(user).delete_event(event1);
    }

    function register(string memory name) public {
        require((wallet_to_user[msg.sender] == address(0x0000000000000000)), "User already exists");
        wallet_to_user[msg.sender] = address(new User(msg.sender, name));
    }

    function update_reputation_score(address user, int256 new_score) public {
        require(msg.sender == reputation_system, "User already exists");
        User(user).update_reputation_score(new_score);
    }

    function set_reputation_system(address new_reputation_system) public {
        require(msg.sender == owner);
        reputation_system = new_reputation_system;
    }
}