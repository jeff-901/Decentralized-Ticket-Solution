pragma solidity >=0.8.0;

contract ReputationSystem {

    mapping(address => uint256) public reputationScores;

    function getReputationScore(address user) external view returns (uint256) {
        return reputationScores[user];
    }

    function updateReputationScore(address user, int256 points) external {
        if (points > 0 || reputationScores[user] >= uint256(-points)) {
            reputationScores[user] += uint256(points);
        }
    }

    function transferUpdate(address user, int256 price, int256 originalprice) external {
        int256 deltaprice = originalprice - price;
        // Ensure deltaprice is non-negative before updating reputation score
        updateReputationScore(user, deltaprice);
    }

    function purchaseUpdate(address user) external {
        updateReputationScore(user, 5);
    }

    function checkCondition(address user) external view returns (bool) {
        if (reputationScores[user] < 500) {
            return false;
        } else if (reputationScores[user] > 1500) {
            // transaction fee deduction of 80%
            return true
        }
        return true;
    }
}