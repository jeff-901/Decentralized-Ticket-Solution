pragma solidity >=0.8.0;
import "./Event.sol";
import "./UserController.sol";
// import "./TicketController.sol";
interface TicketController{
    function createTicket (string memory name, string memory symbol, address initialOwner) external returns (address);
}
contract EventController {
    event OnEventCreated(address);
    // mapping(address => Event) public address_to_event;
    address owner;
    Event[] public events;
    UserController userController;
    TicketController ticketController;

    constructor(address _userController, address _ticketController) {
        userController = UserController(_userController);
        ticketController = TicketController(_ticketController);
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
        {
            userController.get_user_contract_address(msg.sender);
        }

        Event eventInstance = new Event(owner, _name, _description, _link, _seats, _prices, _presale_start_time, _presale_end_time, _event_start_time, _event_end_time, address(userController));
        events.push(eventInstance);
        address event_address = address(eventInstance);
        address ticketNFT = ticketController.createTicket(_name, _link, event_address);
        eventInstance.setNFT(ticketNFT);
        userController.add_user_event(msg.sender, event_address);
        emit OnEventCreated(event_address);
    }

    function getEvent(address payable eventAddress) external view returns (Event) {
        return Event(eventAddress);
    }

    function getEvents() external view returns (Event[] memory) {
        Event[] memory eventList = new Event[](events.length);
        for (uint256 i = 0; i < events.length; i++) {
            eventList[i] = events[i];
        }
        return eventList;
    }
}
