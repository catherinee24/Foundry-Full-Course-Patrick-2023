// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract ManualToken {
    function name() public pure returns(string memory) {
        return "Maverick Token";
    }

    function totalSupply() public pure returns(uint256) {
        return 100 ether;
    }

    function decimals() public pure returns(uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return _owner.balance;
    }
}