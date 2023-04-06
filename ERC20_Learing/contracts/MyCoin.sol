// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyCoin is ERC20,ERC20Burnable,Ownable{
    address commissionAddr;
    constructor(string memory name_, string memory symbol_,address commissionAddr_,uint256 _totalNum) ERC20(name_,symbol_){
        _mint(msg.sender,_totalNum);
        commissionAddr = commissionAddr_;
    }
    //项目方
    function mint(uint256 num) external onlyOwner {
        _mint(msg.sender,num);
    }
    //销毁
   function burnToken(uint256 amount) external{
    burn(amount);
   }
   //支持交易收取手续费 到项目方配置的地址 支持交易销毁部分代币
   function transfer(address from,address to,uint256 value) external{
    uint256  commission = value /200;
    //销毁一定数量的token
    burn(commission/2);
    //收取手续费到项目方指定地址
    _transfer(from, commissionAddr, commission/2);
    //转账到指定账户
    _transfer(from, to, value - commission/2 );
   }
}