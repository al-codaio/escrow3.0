var ConvertLib = artifacts.require("./ConvertLib.sol");
var FundMe = artifacts.require("./FundMe.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.deploy(FundMe);
  
};
