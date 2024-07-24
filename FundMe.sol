// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // ADDRESS : 0x6D41d1dc818112880b40e26BD6FD347E41008eDA
        // ABI 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x6D41d1dc818112880b40e26BD6FD347E41008eDA);
        ( , int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount)/1e18;
        return ethAmountInUSD;
    }
}
// const, immutable
error notOwner();

contract FundMe {
    
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18; 
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Minimum value not matched") ; // 1e18 = 1ETH = 1 * 10 ** 18
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x6D41d1dc818112880b40e26BD6FD347E41008eDA);
        return priceFeed.version();
    }

    function withdraw () public onlyOwner {

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        //transfer
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed!");
        //call
        ( bool callSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
        require(callSuccess, "Call failed!");
    }

    modifier onlyOwner () {
        // require(msg.sender == i_owner, "Not the owner of Contract!");
        if(msg.sender != i_owner) {
            revert notOwner();
        }
        _; // if _; is at the end of the modifier, it means modifier code will run first, if its at the top of the modifier, it means function code calling the modifier will run first them modifier

    }

    // what happens if someone sends this contract ETH without Fundme

    //receive, fallback
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

// require , instead we can use custom errors;
// revert can be called anytime to our liking.