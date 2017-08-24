pragma solidity ^0.4.4;

contract Auction {
	
	struct auction {
		uint deadlineDate;
		uint highestBid;
		address highestBidder;
		address bidReceiver;
	}

	mapping (uint => auction) Auctions;
	uint numAuctions;

}