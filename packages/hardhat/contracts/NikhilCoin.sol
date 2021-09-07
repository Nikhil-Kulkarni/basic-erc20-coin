pragma solidity >=0.6.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract NikhilCoin is ERC20 {

  using SafeMath for uint256;

  uint256 multiplier = 4800;

  event Purchase(address purchaser, uint256 amount);
  event Sell(address seller, uint256 amount);

  constructor() public ERC20("NIKHIL", "NIKHIL") {}

  function buyTokens(uint256 numTokens) public payable {
    require(msg.value >= this.price());
    _mint(msg.sender, numTokens);

    emit Purchase(msg.sender, numTokens);
  }

  function sellTokens(uint256 numTokens) public {
    require(balanceOf(msg.sender) >= numTokens);
    _burn(msg.sender, numTokens);
    (bool sent, ) = msg.sender.call{value: this.price()}("");
    require(sent, "Failed to sent ether");

    emit Sell(msg.sender, numTokens);
  }

  function price() public view returns (uint256) {
    uint256 factoredMultiplier = multiplier.mul(uint256(10) ** uint256(decimals()));
    return (totalSupply().mul(totalSupply())).div(factoredMultiplier);
  }

  function contractBalance() public view returns (uint256) {
    return address(this).balance;
  }

}
