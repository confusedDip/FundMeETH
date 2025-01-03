// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract FundMe {
    uint256 internal minimumUSD = 5e18; // Sets the minimum funding value
    mapping (address funder => uint256 amount) funders; // Keeps a track of the funders

    function fund() public payable{
        require(getConversionRate(msg.value) >= minimumUSD, "Didn't send enough ether. Minimum USD 5.00");
        funders[msg.sender] += getConversionRate(msg.value);    
    }

    function getPrice () public view returns (uint256) {
        /**
            * Network: Sepolia
            * Aggregator: ETH/USD
            * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        */
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        (,int answer,,,) = dataFeed.latestRoundData();
        return uint256(answer) * 1e10;  // msg.value has 18 decimal places, while the returned answer has 8
    }

    function getConversionRate (uint256 ethValue) public view returns (uint256) {
        uint256 ethPrice = getPrice();  // Get the latest USD value of 1ETH
        uint256 usdValue = uint256(ethValue * ethPrice) / 1e18; 
        return usdValue;
    }
}