import "./Ticket.sol";

contract TicketController{
    constructor(){}
        

    function createTicket (string memory name, string memory symbol, address initialOwner)
    public returns (address)
    {
        return address(new Ticket(name, symbol, initialOwner));
    }
}