pragma solidity >=0.8.0;
import "./User.sol";
contract UserController {
    mapping (address => address) wallet_to_user;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier is_resgistered(address user) {
        require(wallet_to_user[user] != address(0));
        _;
    }

    function get_user_contract_address(address user) public view is_resgistered(user) returns(address) {
        return wallet_to_user[user];
    }

    function get_user_reputation_score(address user) public view is_resgistered(user) returns(int256) {
        return User(wallet_to_user[user]).get_reputation_score();
    }

    function get_user_tickets(address user) public view is_resgistered(user) returns(TicketShort[] memory ) {
        return User(wallet_to_user[user]).get_tickets();
    }

    function check_user_tickets(address user, address event_id, uint256 tokenId) public view is_resgistered(user) returns(bool) {
        return User(wallet_to_user[user]).check_ticket(event_id, tokenId);
    }

    function get_user_events(address user) public view is_resgistered(user) returns(address[] memory) {
        return User(wallet_to_user[user]).get_events();
    }

    function add_user_ticket(address user, address event_id, uint256 tokenId) public is_resgistered(user) {
        User(wallet_to_user[user]).add_ticket(event_id, tokenId);
    }

    function add_user_event(address user, address event1) public is_resgistered(user) {
        User(wallet_to_user[user]).add_event(event1);
    }

    function delete_user_ticket(address user, address event_id, uint256 tokenId) public is_resgistered(user) {
        User(wallet_to_user[user]).delete_ticket(event_id, tokenId);
    }

    function delete_user_event(address user, address event1) public is_resgistered(user) {
        User(wallet_to_user[user]).delete_event(event1);
    }

    function register(string memory name) public {
        require((wallet_to_user[msg.sender] == address(0x0000000000000000)), "User already exists");
        wallet_to_user[msg.sender] = address(new User(msg.sender, name));
    }

    function update_reputation_score(address user, int256 new_score) public is_resgistered(user) {
        User(wallet_to_user[user]).update_reputation_score(new_score);
    }

}