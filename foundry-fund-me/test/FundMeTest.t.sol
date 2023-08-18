// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    DeployFundMe public deployFundMe;

    address USER = makeAddr("Cathe");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimunDollarIsFive() external {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() external {
        /**
         * Con los console.log() debugueamos quien era el owner y quien es el msg.sender
         */
        //console.log(fundMe.i_owner());
        //console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    /**
     * Esta funcion no pasara porque hay que hacer un Fork test
     */
    function testPriceFeedVersionIsAccurate() external {
        uint256 version = fundMe.getVersion();
        // La version es 4
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() external {
        vm.expectRevert();
        fundMe.fund(); // Send 0 value.
    }

    function testUpdatesFundedDataStruture() external {
        vm.prank(USER); // the next TX will be sent by Cathe.
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmounFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFundersToArrayOfFunders() external {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
}
