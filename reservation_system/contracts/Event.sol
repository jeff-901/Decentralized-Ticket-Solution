pragma solidity >=0.8.0;

import "./UserController.sol";

contract Event {
    event OnTicketPurchased(address buyer, uint256 price);

    UserController public userController;

    address public owner;
    string public name;
    string public description;
    string public link;
    uint256[] public prices; // prices are all the possible values of tickets
    uint256[] public seats; // prices[i] has seats[i] tickets
    address[][] public seat_owners;
    uint256 public presale_start_time;
    uint256 public presale_end_time;
    uint256 public event_start_time;
    uint256 public event_end_time;
    address[][] public lottery_pool;  // lottery_pool[i][j] means the j-th user register the prices[i] ticket

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
        uint256 _event_end_time,
        address _userController
    ) {
        userController = UserController(_userController);
        owner = _owner;
		name = _name;
        description = _description;
        link = _link;
		seats = _seats;
        prices = _prices;
        presale_start_time = _presale_start_time;
        presale_end_time = _presale_end_time;
        event_start_time = _event_start_time;
        event_end_time = _event_end_time;

        for(uint256 i = 0; i < seats.length; i++) {
            lottery_pool.push(new address[](0));
            seat_owners.push(new address[](seats[i]));
            // init NFT ticket
        }
	}

    // Check if the specified ticket seat is owned by a given user
    function check_ticket_ownership(uint256 seatNumber, uint256 price, address user) public view returns (bool) {
        uint256 target = seats.length;
        for(uint256 i = 0; i < seats.length; i++) {
            if (seats[i] == price){
                target = i;
                break;
            }
        }
        require(target < seats.length, "price not found");
        require(seatNumber < seats[target], "Seat does not exist");
        require(seat_owners[target][seatNumber] != address(0), "Seat is not owned");

        return seat_owners[target][seatNumber] == user;
    }

	// Check if a user has sufficient funds to buy a ticket
	function check_balance(uint256 price, address user) public view returns (bool) {
        return address(user).balance >= price;
    }

    // During the presale stage if the user has sufficient funds, place the ticket in the lottery pool
    // Collect the money and place the ticket in the lottery pool
    // The ticket is placed in the lottery pool by adding the user's address to the array of addresses
    function buy_ticket(uint256 price) public payable {
        require(block.timestamp >= presale_start_time, "Presale has not started yet");
        require(block.timestamp < presale_start_time, "Presale has closed");   
        // 1. Check if the user has sufficient funds to buy the ticket
        require(check_balance(price, msg.sender), "Insufficient funds");
        // 2. Place the user address in the lottery pool
        for (uint256 i = 0; i < prices.length; i++) {
            if (prices[i] == price) {
                lottery_pool[i].push(msg.sender);
            }
        }
        // 3. Transfer the money from the buyer to the contract owner
        payable(owner).transfer(price);
        // 4. Emit an event to signal the ticket purchase
        emit OnTicketPurchased(msg.sender, price);
    }

	// Contract owner withdraws the entire balance from the contract and sends it to a specified user address
	function withdraw(address payable user) public {
		require(msg.sender == owner);
        require (block.timestamp > event_end_time, "Withdrawal is not allowed yet");
        user.transfer(address(this).balance);
    }

    // User cancels their registration and gets a refund
    function cancel_registration() public {
        require(block.timestamp < event_start_time, "Event has already started");

        // If the user is in the lottery pool, they can cancel their registration and get a refund
        bool found = false;
        for(uint256 i = 0; i < seats.length; i++){
            for (uint256 j = 0; j < lottery_pool[i].length; j++) {
                if (lottery_pool[i][j] == msg.sender) {
                    uint256 price = prices[i];
                    require(address(this).balance >= price, "Contract balance insufficient");
                    // Remove the user from the lottery pool
                    lottery_pool[i][j] = address(0);
                    // Transfer the money from the contract to the user
                    payable(msg.sender).transfer(price);
                    found = true;
                    break;
                }
            }
            if (found) {
                break;
            }
        }
    }

    //  Distribute the tickets to the users in the lottery pool based on the length of seats
    function distribute_ticket(uint256 seed) public {
        require(block.timestamp > presale_end_time, "Presale has not ended yet");
        require(msg.sender == owner, "Only the contract owner can distribute tickets");

        // Distribute the tickets to the users in the lottery pool based on the length of seats
        for (uint256 i = 0; i < seats.length; i++) {
            uint256 offset = seed % lottery_pool[i].length;
            // select seats[i] winners starting from offset in the lottery pool
            uint256 selected = 0;
            uint256 j = 0;
            while (j < lottery_pool[i].length) {
                if (lottery_pool[i][j] == address(0)){
                    continue;
                }
                if (selected < seats[i]){
                    uint256 winner_idx = (offset + j) % lottery_pool[i].length;
                    address winner = lottery_pool[i][winner_idx];
                    seat_owners[i][selected] = winner;
                    selected++;
                    int256 new_reputation_score = userController.get_user_reputation_score(winner) + 5;
                    userController.update_reputation_score(winner, new_reputation_score);
                }else{
                    if (lottery_pool[i][j] != address(0)) {
                        uint256 price = prices[i];
                        payable(lottery_pool[i][j]).transfer(price);
                        lottery_pool[i][j] = address(0);
                    }
                }
                j++;
            }
        }
    }
}
