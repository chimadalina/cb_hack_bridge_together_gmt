// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {L1StandardBridge} from "@eth-optimism/contracts/L1/messaging/L1StandardBridge.sol";
import "hardhat/console.sol";

contract L1_Contract {
    address public L2Distributor;

    address payable[] addresses;
    uint256[] balances;
    uint256 total_balance;

    constructor(address _l2Distributor) {
        L2Distributor = _l2Distributor;
    }

    function deposit() public payable {
        require(msg.value > 0, "Value should be greated than 0");
        addresses.push(payable(msg.sender));
        balances.push(msg.value);
        total_balance += msg.value;

        console.log("CONTRACT sender balance",msg.sender.balance);

        console.log("CONTRACT addresses length", addresses.length);
        if (addresses.length == 3){
            console.log("CONTRACT about to goToBridge ");
            goToBridge();
            _reset();
        }
    }

    function goToBridge() public payable {
        console.log("CONTRACT goToBridge total_balance ", total_balance);
        uint256 remaining_value = total_balance - 200000;
        console.log("CONTRACT goToBridge ", remaining_value);
        L1StandardBridge(payable(msg.sender)).depositETHTo {value: remaining_value} (
        L2Distributor,
        200000,
        abi.encodeWithSignature(
                "depositFunds(address payable[] calldata, uint256[] calldata)",
                addresses,
                balances
            )
        );
    }

    function _reset() private {
        total_balance = 0;
        addresses = new address payable[](0);
        balances = new uint256[](0);
    }

    function getCount() public view returns(uint count) {
    return addresses.length;
    }

    function getTotalBalance() public view returns(uint256 count) {
    return total_balance;
    }

    function getSenderInitialBalance(address a) public view returns(uint256 count) {
        return a.balance;
    }
    
    function getContractBalance() public view returns(uint256 count) {
        return address(this).balance;
    }
}
