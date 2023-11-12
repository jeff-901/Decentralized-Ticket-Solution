pragma solidity >=0.8.0;

contract Event {
    event OnTicketPurchased(address buyer, uint256 seatNumber, uint256 price);

    address public owner;
    string public name;
    string public description;
    string public link;
    uint256[] public seats;
    uint256[] public prices;
    address[] public seat_owners;
    uint256 public seed;

	constructor(
        address _owner,
        string memory _name,
        string memory _description,
        string memory _link,
        uint256[] memory _seats,
		uint256[] memory _prices
    ) {
        owner = _owner;
		name = _name;
        description = _description;
        link = _link;
		seats = _seats;
        prices = _prices;
        seat_owners = new address[](seats.length);
	}

    // Check if the specified ticket seat is owned by a given user
    function check_ticket_ownership(uint256 seatNumber, address user) public view returns (bool) {
        require(seatNumber < seats.length, "Seat does not exist");
        require(seat_owners[seatNumber] != address(0), "Seat is not owned");

        return seat_owners[seatNumber] == user;
    }

	//TODO: not sure what to do with this function
	function check_balance(address event1) public view returns (uint256) {
	}

    function buy_ticket(uint256 seatNumber) public payable {
        require(seatNumber < seats.length, "Invalid seat number");
        require(seat_owners[seatNumber] == address(0), "Seat is already taken");
        require(msg.value >= prices[seatNumber], "Insufficient funds");

        // Transfer ownership of the seat
        seat_owners[seatNumber] = msg.sender;

        // Emit an event to signal the ticket purchase
        emit OnTicketPurchased(msg.sender, seatNumber, msg.value);
    }
	// Contract owner withdraws the entire balance from the contract and sends it to a specified user address
	function withdraw(address payable user) public {
		require(msg.sender == owner);
        user.transfer(address(this).balance);
    }
}
