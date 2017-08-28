pragma solidity ^0.4.4;

contract FundMe {

	//Funders in the campaign
	struct Funder { 
		address funderAddress;
		uint fundAmount;
	}

	//Single Campaign details
	struct Campaign {
		address campaignAddress;
		uint fundingGoal;
		uint numFunders;
		uint amountUSD;
		uint deadlineDate;
		mapping (uint => Funder) funders;
	}

	//Meta Campaign details
	mapping (uint => Campaign) campaigns;
	uint numCampaigns;

	//Create new campaign
	function newCampaign(address _campaignAddress, uint _fundingGoal, uint _deadlineDate) returns (uint campaignID) {
		campaignID = numCampaigns++;
		Campaign c = campaigns[campaignID];
		c.campaignAddress = _campaignAddress;
		c.fundingGoal = _fundingGoal;
		c.deadlineDate = block.number + _deadlineDate;
	}

	//Funder funds a campaign
	function fund(uint _campaignID) {
		Campaign c = campaigns[campaignID];
		Funder f = c.funders[c.numFunders++];
		f.funderAddress = msg.sender;
		f.fundAmount = msg.value;
		c.amount += f.fundAmount;
	}

	//Check if campaign funding goal is reached (either funding goal met or deadline reached)
	function checkGoalReached(uint _campaignID) returns (bool _goalReached) {
		Campaign c = campaigns[_campaignID];
		if (c.amountUSD >= c.fundingGoal) {
			c.campaignAddress.send(c.amountUSD);
			c.amountUSD = 0;
			c.campaignAddress = 0;
			c.fundingGoal = 0;
			c.deadlineDate = 0;
			uint i = 0;
			uint f = c.numFunders;
			c.numFunders = 0;
			while (i <= f) {
				c.funders[i].funderAddress = 0;
				c.funders[i].fundAmount = 0;
				i++;
			}
			return true;
		}		
		if (c.deadlineDate <= block.number) {
			uint j = 0;
			uint n = c.numFunders;
			c.amountUSD = 0;
			c.campaignAddress = 0;
			c.fundingGoal = 0;
			c.deadlineDate = 0;
			c.numFunders = 0;
			while (j <= n) {
				c.funders[j].funderAddress.send(c.funders[j].fundAmount);
				c.funders[j].funderAddress = 0;
				c.funders[j].fundAmount = 0;
				j++;
			}
			return true;
		}
		return false;
	}	

}