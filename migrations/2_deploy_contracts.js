var ConvertLib = artifacts.require("./ConvertLib.sol");
var FundMe = artifacts.require("./FundMe.sol");
var Auction = artifacts.require("Auction");
var decentralizedAuction = artifacts.require("decentralizedAuction");
// var MetaCoin = artifacts.require("./MetaCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.deploy(FundMe);
  deployer.deploy(Auction);
  deployer.deploy(decentralizedAuction);  
};
