//编写部署脚本
const CrowFunding = artifacts.require("CrowFunding");
module.exports = function(deployer) {
    deployer.deploy(CrowFunding);
}