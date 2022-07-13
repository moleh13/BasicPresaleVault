// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./IERC20.sol";

contract Core {
    
    uint presaleAmount;
    uint totalAmount;
    mapping (address => uint) amountByUser;
    uint startingTime;
    uint endTime;
    address tokenAddress;
    address payable owner;


    constructor(uint _amount, address _ierc20address) {
        presaleAmount = _amount;
        startingTime = block.timestamp;
        endTime = startingTime + 180;
        tokenAddress = _ierc20address;
        owner = payable(msg.sender);
    }

    function deposit(uint _amount) public payable {
        require(block.timestamp < endTime, "Deadline is over");
        amountByUser[msg.sender] += _amount;
        totalAmount += _amount;
    }

    function withdraw() public {
        require(block.timestamp > endTime, "Deadline is not over, yet");
        uint amount = amountByUser[msg.sender] / totalAmount * 1e18;
        IERC20(tokenAddress).transfer(msg.sender, amount);
    }

    function checkDeadline() public view returns (uint) {
        return endTime - block.timestamp;
    }

    function conclude() public payable {
        require(msg.sender == owner, "Only owner can conclude the presale");
        bool sent = owner.send(address(this).balance);
        require(sent, "Failed to send Ether");
    }

}