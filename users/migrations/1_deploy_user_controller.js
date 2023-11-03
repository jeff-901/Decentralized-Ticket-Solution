const UserController_Contract = artifacts.require("UserController");

module.exports = function(deployer) {
  deployer.deploy(UserController_Contract);
};