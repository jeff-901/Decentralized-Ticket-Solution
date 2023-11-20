const UserController_Contract = artifacts.require("UserController");
const EventController = artifacts.require("EventController");

module.exports = function(deployer) {
  deployer.deploy(UserController_Contract).then(function() {
    return deployer.deploy(EventController, UserController_Contract.address);
  });
};