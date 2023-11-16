const EventController = artifacts.require("EventController");

module.exports = function(deployer) {
  deployer.deploy(EventController);
};
