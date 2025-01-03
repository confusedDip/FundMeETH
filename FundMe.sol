// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;   // Attaching the library functions for uint256 variables

    uint256 internal minimumUSD = 5e18; // Sets the minimum funding value
    address[] funders; // Keeps a track of the funders
    mapping (address funder => uint256 amount) fundedAmounts; // Keeps a track of the funded amounts

    address public owner; // Deployer of the contract

    constructor() {
        owner = msg.sender; // The deployer of the smart contract is the owner of the contract
    }

    // A method that allows funders to send money through the function
    function fund() public payable{
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough ether. Minimum USD 5.00");
        fundedAmounts[msg.sender] += msg.value.getConversionRate();    
    }

    function withdraw() public ownerOnly{

        for (uint funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            fundedAmounts[funder] = 0;  // Sets the amount funded to be Zero
        }
        // Reset the funders array
        funders = new address[](0);

        // Withdraw the balance
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess, "Transaction Unsuccessful");
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "Can only be withdrawn by the Owner!");
        _;
    }

    // In case, funds are externally sent without calling the fund() function
    receive() external payable { fund(); }

    fallback() external payable { fund(); }
    
}
