pragma solidity >=0.8.0;
struct TicketShort {
    address event_id;
    uint256 tokenId;
}

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
    TicketShort[] tickets;
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

    function get_tickets() public view returns (TicketShort[] memory){
        require(msg.sender == user_controller || msg.sender == original_user_wallet);
        return tickets;
    }

    function check_ticket(address event_id, uint256 tokenId) public view returns (bool){
        require(msg.sender == user_controller || msg.sender == original_user_wallet);
        bool found = false;
        for (uint idx = 0; idx < tickets.length; idx++){
            if ((tickets[idx].event_id == event_id) && (tickets[idx].tokenId == tokenId)) {
                return true;
            }
        }
        return found;
    }

    function add_ticket(address event_id, uint256 tokenId) public {
        tickets.push(TicketShort(event_id, tokenId));
        amount_tickets += 1;
    }

    function delete_ticket(address event_id, uint256 tokenId) public {
        for(uint256 idx = 0; idx < amount_tickets; idx++) {
            if ((tickets[idx].event_id == event_id) && (tickets[idx].tokenId == tokenId)) {
                tickets[idx].event_id = address(0);
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