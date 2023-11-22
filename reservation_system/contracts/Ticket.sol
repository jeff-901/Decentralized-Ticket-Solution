// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ticket is ERC721Enumerable, Ownable {
    struct TicketMetadata {
        uint256 ticketID;
        string eventName;
    }

    // Mapping from token ID to ticket metadata
    mapping(uint256 => TicketMetadata) private _ticketMetadata;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(
        address to,
        uint256 tokenId,
        uint256 ticketID,
        string memory eventName
    ) public onlyOwner {
        _mint(to, tokenId);
        TicketMetadata storage metadata = _ticketMetadata[tokenId];
        metadata.ticketID = ticketID;
        metadata.eventName = eventName;
    }

    // Retrieve ticket metadata for a given token ID
    function getTicketMetadata(uint256 tokenId)
        public
        view
        returns (
            uint256 ticketID,
            string memory eventName
        )
    {
        TicketMetadata storage metadata = _ticketMetadata[tokenId];
        return (
            metadata.ticketID,
            metadata.eventName
        );
    }

        // Transfer ownership of a ticket to another address
    function transferTicketOwnership(uint256 tokenId, address newOwner) public {
        require(ownerOf(tokenId) == msg.sender, "Only the current owner can transfer ownership");
        _transfer(msg.sender, newOwner, tokenId);
    }
}
