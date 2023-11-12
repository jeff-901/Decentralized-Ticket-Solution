pragma solidity >=0.8.0;
import "./Event.sol";

contract EventController {
    mapping(address => Event) public events;
    address owner;

    constructor() {
        owner = msg.sender; 
    }

    function createEvent(
        string memory _name,
        string memory _description,
        string memory _link,
        uint256[] memory _seats,
        uint256[] memory _prices
    ) public {
        Event eventInstance = new Event(owner, _name, _description, _link, _seats, _prices);
        address event_address = address(eventInstance);
        events[event_address] = eventInstance;
    }

    function getEvent(address eventAddress) external view returns (Event) {
        return events[eventAddress];
    }

}
