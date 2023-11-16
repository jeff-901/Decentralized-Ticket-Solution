pragma solidity >=0.8.0;
import "./Event.sol";

contract EventController {
    mapping(address => Event) public address_to_event;
    address owner;
    Event[] public events;

    constructor() {
        owner = msg.sender; 
    }

    function createEvent(
        string memory _name,
        string memory _description,
        string memory _link,
        uint256[] memory _seats,
        uint256[] memory _prices,
        uint256 _presale_start_time,
        uint256 _presale_end_time,
        uint256 _event_start_time,
        uint256 _event_end_time
    ) public {
        Event eventInstance = new Event(owner, _name, _description, _link, _seats, _prices, _presale_start_time, _presale_end_time, _event_start_time, _event_end_time);
        address event_address = address(eventInstance);
        address_to_event[event_address] = eventInstance;
    }

    function getEvent(address eventAddress) external view returns (Event) {
        return address_to_event[eventAddress];
    }

    function getEvents() external view returns (Event[] memory) {
        Event[] memory eventList = new Event[](events.length);
        for (uint256 i = 0; i < events.length; i++) {
            eventList[i] = events[i];
        }
        return eventList;
    }

}
