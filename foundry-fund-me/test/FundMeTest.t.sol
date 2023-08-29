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
    uint256 constant GAS_PRICE = 1;

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
        assertEq(fundMe.getOwner(), msg.sender);
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

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() external funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunded() external funded {
        //Arrenge
        // Empezamos viendo cuanto es el balance del Owner y del contrato FundMe antes de hacer la TX.
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        // fundMe.getOwner() por que solo el owner puede llamar a esta funcion.
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        // Nos aseguramos de que hayamos retirado todo el dinero del contrato FundMe.
        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() external funded {
        //Arrange
        // Usamos uint160 porque tiene la misma cantidad de bytes que un address
        uint160 numberOfFunders = 10;
        uint160 startingFundersIndex = 1;

        // A traves de este for loop vamos a crear addresses para los 10 numberOfFunders
        for (uint160 i = startingFundersIndex; i < numberOfFunders; ++i) {
            //vm.prank: new address
            //vm.deal: fund the new address
            //Fondear el contrato FundMe

            // HOAX: Establece un prank de una dirección que tiene algo de éter.
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        //uint256 gasStart = gasleft(); // gasleft: Es una funcion de solidity que nos permite saber cuanto gas queda en el contrato.
        //vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //uint256 gasEnd = gasleft();
        //uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; // tx.gasprice es otra funcion de solidity que nos dice el precio actual del Gas.
        //console.log(gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }
}
