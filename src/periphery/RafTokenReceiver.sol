// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.14;

import { Owned } from "solmate/src/auth/Owned.sol";

/**
 * @title RafTokenReceiver
 * @author CyberConnect
 * @notice A contract that receive native token and record the amount.
 */
contract RafTokenReceiver is Owned {
    /*//////////////////////////////////////////////////////////////
                                STATES
    //////////////////////////////////////////////////////////////*/

    mapping(address => uint256) public deposits;
    uint256 public requiredAmount;

    /*//////////////////////////////////////////////////////////////
                                 EVENT
    //////////////////////////////////////////////////////////////*/

    event RafDeposit(address from, uint256 amount);
    event RafWithdraw(address to, uint256 amount);
    event RafUpdateRequiredAmount(uint256 amount);

    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address owner, uint256 amount) Owned(owner) {
        require(amount > 0, "INVALID_AMOUNT");
        requiredAmount = amount;
    }

    /*//////////////////////////////////////////////////////////////
                                 EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function deposit() external payable {
        require(msg.value == requiredAmount, "WRONG_AMOUNT");
        deposits[msg.sender] += msg.value;
        emit RafDeposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyOwner {
        payable(owner).transfer(amount);
        emit RafWithdraw(owner, amount);
    }

    function setRequiredAmount(uint256 newAmount) external onlyOwner {
        require(newAmount > 0, "INVALID_AMOUNT");
        emit RafUpdateRequiredAmount(newAmount);
        requiredAmount = newAmount;
    }
}
