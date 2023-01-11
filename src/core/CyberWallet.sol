// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.14;

import { BaseWallet } from "../base/BaseWallet.sol";
import { DataTypes } from "../libraries/DataTypes.sol";

contract CyberWallet is BaseWallet {
    address public entryPoint;
    uint256 public nonce;

    constructor(
        address _entryPoint,
        address _owner,
        address _guardianModule
    ) BaseWallet(_owner, _guardianModule) {
        require(_entryPoint != address(0));
        entryPoint = _entryPoint;
    }

    function execTransaction(
        address to,
        uint256 value,
        bytes memory data
    ) public virtual {
        require(msg.sender == entryPoint);
        execute(to, value, data, gasleft());
    }

    function validateUserOp(
        DataTypes.UserOperation calldata userOp,
        bytes32 userOpHash,
        address,
        uint256 missingAccountFunds
    ) external returns (uint256) {
        if (nonce != 0) {
            require(msg.sender == entryPoint, "account: not from entrypoint");
            require(
                _checkSignature(userOpHash, userOp.signature),
                "WRONG_SIGNATURE"
            );

            if (userOp.initCode.length == 0) {
                require(nonce == userOp.nonce, "account: invalid nonce");
            }
            ++nonce;
        }
        if (missingAccountFunds > 0) {
            (bool success, ) = payable(msg.sender).call{
                value: missingAccountFunds
            }("");
            (success);
            //ignore failure (its EntryPoint's job to verify, not account.)
        }
        return 0; //always return 0 as this function doesn't support time based validation
    }

    // TODO: auth
    function replaceEntrypoint(address newEntrypoint) public {
        entryPoint = newEntrypoint;
    }
}
