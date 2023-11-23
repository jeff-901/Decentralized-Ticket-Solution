// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ticket is ERC721Enumerable, Ownable {
    struct TicketMetadata {
        string eventName;
        uint256 price;
        address eventID;
    }

    // Mapping from token ID to ticket metadata
    mapping(uint256 => TicketMetadata) private _ticketMetadata;

    constructor(string memory name, string memory symbol, address initialOwner) 
    ERC721(name, symbol) Ownable(initialOwner){}

    function mint(
        address to,
        uint256 tokenId,
        string memory eventName,
        uint256 price,
        address eventID
    ) public onlyOwner {
        _mint(to, tokenId);
        TicketMetadata storage metadata = _ticketMetadata[tokenId];
        metadata.eventName = eventName;
        metadata.eventID = eventID;
        metadata.price = price;
    }

    // Retrieve ticket metadata for a given token ID
    function getTicketMetadata(uint256 tokenId)
        public
        view
        returns (
            string memory eventName,
            uint256 price,
            address eventID
        )
    {
        TicketMetadata storage metadata = _ticketMetadata[tokenId];
        return (
            metadata.eventName,
            metadata.price,
            metadata.eventID
        );
    }

        // Transfer ownership of a ticket to another address
    function transferTicketOwnership(uint256 tokenId, address newOwner) public {
        require(ownerOf(tokenId) == msg.sender, "Only the current owner can transfer ownership");
        _transfer(msg.sender, newOwner, tokenId);
    }
}
