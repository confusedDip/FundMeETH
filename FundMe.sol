// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;   // Attaching the library functions for uint256 variables

    uint256 internal minimumUSD = 5e18; // Sets the minimum funding value
    mapping (address funder => uint256 amount) funders; // Keeps a track of the funders

    function fund() public payable{
        // require(getConversionRate(msg.value) >= minimumUSD, "Didn't send enough ether. Minimum USD 5.00");
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough ether. Minimum USD 5.00");
        funders[msg.sender] += msg.value.getConversionRate();    
    }

    
}