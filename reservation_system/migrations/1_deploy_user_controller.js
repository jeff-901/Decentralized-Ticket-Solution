const UserController_Contract = artifacts.require("UserController");
const TicketController_Contract = artifacts.require("TicketController");
const EventController = artifacts.require("EventController");

module.exports = function(deployer) {
  deployer.deploy(UserController_Contract).then(function() {
    return deployer.deploy(TicketController_Contract).then(function(){
      return deployer.deploy(EventController, UserController_Contract.address, TicketController_Contract.address);
    });
  });
};