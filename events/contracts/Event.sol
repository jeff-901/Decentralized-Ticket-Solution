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
    mapping(address => uint256) public user_to_seatNumber;
    uint256 public presale_start_time;
    uint256 public presale_end_time;
    uint256 public event_start_time;
    uint256 public event_end_time;
    address[] public lottery_pool;

	constructor(
        address _owner,
        string memory _name,
        string memory _description,
        string memory _link,
        uint256[] memory _seats,
		uint256[] memory _prices,
        uint256 _presale_start_time,
        uint256 _presale_end_time,
        uint256 _event_start_time,
        uint256 _event_end_time
    ) {
        owner = _owner;
		name = _name;
        description = _description;
        link = _link;
		seats = _seats;
        prices = _prices;
        seat_owners = new address[](seats.length);
        presale_start_time = _presale_start_time;
        presale_end_time = _presale_end_time;
        event_start_time = _event_start_time;
        event_end_time = _event_end_time;
	}

    // Check if the specified ticket seat is owned by a given user
    function check_ticket_ownership(uint256 seatNumber, address user) public view returns (bool) {
        require(seatNumber < seats.length, "Seat does not exist");
        require(seat_owners[seatNumber] != address(0), "Seat is not owned");

        return seat_owners[seatNumber] == user;
    }

	// Check if a user has sufficient funds to buy a ticket
	function check_balance(uint256 seatNumber, address user) public view returns (bool) {
        uint256 price = prices[seatNumber];
        return address(user).balance >= price;
    }

    // During the presale stage if the user has sufficient funds, place the ticket in the lottery pool
    // Collect the money and place the ticket in the lottery pool
    // The ticket is placed in the lottery pool by adding the user's address to the array of addresses
    function buy_ticket(uint256 seatNumber, address user) public payable {
        require(block.timestamp >= presale_start_time, "Presale has not started yet");
        require(block.timestamp < presale_start_time, "Presale has closed");   
        // 1. Check if the user has sufficient funds to buy the ticket
        require(check_balance(seatNumber, user), "Insufficient funds");
        // 2. Place the user address in the lottery pool
        lottery_pool.push(user);
        // 3. Transfer the money from the buyer to the contract owner
        uint256 price = prices[seatNumber];
        payable(owner).transfer(price);
        // 4. Update the user and seat price mapping
        user_to_seatNumber[user] = seatNumber;
        // 5. Emit an event to signal the ticket purchase
        emit OnTicketPurchased(msg.sender, seatNumber, msg.value);
    }

	// Contract owner withdraws the entire balance from the contract and sends it to a specified user address
	function withdraw(address payable user) public {
		require(msg.sender == owner);
        require (block.timestamp > event_end_time, "Withdrawal is not allowed yet");
        user.transfer(address(this).balance);
    }

    // User cancels their registration and gets a refund
    function cancel_registration(address user) public {
        require(block.timestamp < event_start_time, "Event has already started");

        // If the user is in the lottery pool, they can cancel their registration and get a refund
        for (uint256 i = 0; i < lottery_pool.length; i++) {
            if (lottery_pool[i] == user) {
                uint256 seatNumber = user_to_seatNumber[user];
                uint256 price = prices[seatNumber];
                require(address(this).balance >= price, "Contract balance insufficient");
                // Remove the user from the lottery pool
                lottery_pool[i] = address(0);
                // Transfer the money from the contract to the user
                payable(user).transfer(price);
                // Remove the user's registration
                delete user_to_seatNumber[user];

                break;
            }
        }
    }

    //  Distribute the tickets to the users in the lottery pool based on the length of seats
    function distribute_ticket(uint256 seed) public {
        require(block.timestamp > presale_end_time, "Presale has not ended yet");
        require(msg.sender == owner, "Only the contract owner can distribute tickets");
        uint256 offset = seed % lottery_pool.length;
        // Distribute the tickets to the users in the lottery pool based on the length of seats
        //FIXME: How to deal with tickets of multiple prices?
        uint256 j = 0;
        while (j < seats.length) {
            uint256 index = (offset + j) % lottery_pool.length;
            address userToAssign = lottery_pool[index];
            if (userToAssign != address(0)) {
                uint256 seatNumber = seats[j];
                seat_owners[seatNumber] = userToAssign;
                // Set the user's seat number to 0 to indicate that they have been assigned a seat
                lottery_pool[index] = address(0);
                j += 1;
            }
        }
        // Refund the remaining users in the lottery pool
        for (uint256 i = 0; i < lottery_pool.length; i++) {
            if (lottery_pool[i] != address(0)) {
                uint seatNumber = user_to_seatNumber[lottery_pool[i]];
                uint256 price = prices[seatNumber];
                payable(lottery_pool[i]).transfer(price);
                delete lottery_pool[i];
            }
        }
    }
}
