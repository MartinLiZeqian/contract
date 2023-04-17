const MyCoin = artifacts.require("MyCoin");
module.exports = function(deployer) {
    deployer.deploy(MyCoin,"my coin1","mc1","0xa9f29F35da802ddF6A661fd7e06B352D2202e7cc",1000000);
}