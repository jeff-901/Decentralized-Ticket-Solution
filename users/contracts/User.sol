pragma solidity >=0.8.0;

contract User {
    // event OnAddCampaign(address user, address capmaign_addr, uint256 Id);
    // event OnAddTicket(address user, address attend_addr, uint256 Id);
    // event OnCompleteCampaign(address user, address capmaign_addr, uint256 Id);
    // event OnCompleteTicket(address user, address attend_addr, uint256 Id);

    address public user_controller;
    address private original_user_wallet;
    int256 public reputation_score;
    string name;
    uint256 amount_tickets = 0;
    uint256 amount_events = 0;
    address[] tickets;
    address[] events;

    constructor(address user_wallet, string memory name_arg) public {
        // Contract "User" is initialized via "UserController"
        name = name_arg;
        original_user_wallet = user_wallet;
        user_controller = msg.sender;
    }

    function update_reputation_score(int256 score) public {
        require(msg.sender == user_controller);
        reputation_score = score;
    }

    function get_reputation_score() public view returns (int256) {
        return reputation_score;
    }

    function get_tickets() public view returns (address[] memory){
        require(msg.sender == user_controller || msg.sender == original_user_wallet);
        return tickets;
    }

    function add_ticket(address ticket) public {
        tickets.push(ticket);
        amount_tickets += 1;
    }

    function delete_ticket(address ticket) public {
        for(uint256 idx = 0; idx < amount_tickets; idx++) {
            if (tickets[idx] == ticket) {
                tickets[idx] = address(0);
            }
        }
    }

    function get_events() public view returns (address[] memory){
        require(msg.sender == user_controller || msg.sender == original_user_wallet);
        return events;
    }

    function add_event(address event1) public {
        events.push(event1);
        amount_events += 1;
    }

    function delete_event(address event1) public {
        for(uint256 idx = 0; idx < amount_events; idx++) {
            if (events[idx] == event1) {
                events[idx] = address(0);
            }
        }
    }
}