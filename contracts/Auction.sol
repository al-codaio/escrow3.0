pragma solidity ^0.4.4;

contract Auction {
	
	struct auction {
		uint deadlineDate;
		uint highestBid;
		address highestBidder;
		address bidReceiver;
	}

	mapping (uint => auction) public Auctions;
	uint public numAuctions;

	function startAuction(uint _timeLimit) returns (uint _auctionID) {
		_auctionID = numAuctions++;
		Auctions[_auctionID].deadlineDate = block.number + _timeLimit;
		Auctions[_auctionID].bidReceiver = msg.sender;
	}

	function bid(uint _ID) payable returns (address _highestBidder) {
		auction storage a = Auctions[_ID];
		if (a.highestBid + 1*10^18 > msg.value || a.deadlineDate > block.number) {
			msg.sender.transfer(msg.value);
			return a.highestBidder;			
		}
		a.highestBidder.transfer(a.highestBid);
		a.highestBidder = msg.sender;
		a.highestBid = msg.value;
		return msg.sender;
	}

	function endAuction(uint _ID) returns (address _highestBidder) {
		auction storage a = Auctions[_ID];
		if (block.number >= a.deadlineDate) {
			a.bidReceiver.transfer(a.highestBid);
			a.highestBid = 0;
			a.highestBidder = 0;
			a.deadlineDate = 0;
			a.bidReceiver = 0;
		}
	}

}

contract decentralizedAuction {
	
	struct auction {
		uint deadlineDate;
		uint highestBid;
		address highestBidder;
		uint bidHash;
		address bidReceiver;
		uint thirdPartyFee;
		address thirdParty;
		uint deliveryDeadline;
	}

	mapping (uint => auction) public Auctions;
	uint public numAuctions;

	function startAuction(uint _timeLimit, address _thirdParty, uint _thirdPartyFee, uint _deliveryDeadline) returns (uint _auctionID) {
		_auctionID = numAuctions++;
		auction storage a = Auctions[_auctionID];
		a.deadlineDate = block.number + _timeLimit;
		a.bidReceiver = msg.sender;
		a.thirdParty = _thirdParty;
		a.thirdPartyFee = _thirdPartyFee;
		a.deliveryDeadline = block.number + _timeLimit + _deliveryDeadline;
	}

	function bid(uint _ID, uint _bidderHash) payable returns (address _highestBidder) {
		auction storage a = Auctions[_ID];
		if (a.highestBid + 1*10^18 > msg.value || a.deadlineDate > block.number) {
			msg.sender.transfer(msg.value);
			return a.highestBidder;			
		}
		a.highestBidder.transfer(a.highestBid);
		a.highestBidder = msg.sender;
		a.highestBid = msg.value;
		a.bidHash = _bidderHash;
		return msg.sender;
	}

	function endAuction(uint _ID, uint _key) returns (address _highestBidder) {
		auction storage a = Auctions[_ID];
		if (block.number >= a.deadlineDate && sha3(_key) == sha3(a.bidHash)) {
			a.bidReceiver.transfer(a.highestBid - a.thirdPartyFee);
			a.thirdParty.transfer(a.thirdPartyFee);
			clean(_ID);
		}
	}

	function notDelivered(uint _ID) {
		auction storage a = Auctions[_ID];
		if (block.number >= a.deliveryDeadline && msg.sender == a.highestBidder) {
			clean(_ID);
		}
	}

	function clean(uint _ID) private {
		auction storage a = Auctions[_ID];
		a.highestBid = 0;
		a.highestBidder = 0;
		a.deadlineDate = 0;
		a.deliveryDeadline = 0;
		a.bidReceiver = 0;
		a.bidHash = 0;
		a.thirdParty = 0;
		a.thirdPartyFee = 0;
	}

}