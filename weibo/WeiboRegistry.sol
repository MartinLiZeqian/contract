// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
//微博平台
contract WeiboRegistry{
    //账户数量
    uint _numberOfAccounts;
    //管理员账号
    address _adminAccount;
    //id->address
    mapping(uint=>address) _idToAccount;
    //name->address
    mapping (string => address) _nameToAccount;
    //address -> name
    mapping (address => string) _accountToName;
    //构造函数
    constructor() {
        _numberOfAccounts = 0;
        _adminAccount = msg.sender;
    }
    modifier OnlyAdmin{
        require(msg.sender == _adminAccount);
        _;
    }
    //用户注册
    function register(string memory name,address addr) external{
        require(bytes(name).length <= 20&&bytes(name).length != 0);
        require(addr != address(0));
        //去重
        require(_nameToAccount[name] == address(0));
        _idToAccount[_numberOfAccounts] = addr;
        _nameToAccount[name] = addr;
        _accountToName[addr] = name;
        _numberOfAccounts++;
    }
    //获取账户数量
    function getNumberOfAccounts( ) external view returns (uint ) {
        return _numberOfAccounts;
    }
    //id -> address
    function getAccOfId(uint id) external view returns(address) {
        return _idToAccount[id];
    }
    //name -> address
    function getNameOfAccount(address acc) external view returns(string memory) {
        return _accountToName[acc];
    }
    //address -> name
    function getAccOfName(string memory name ) external view returns(address) {
        return  _nameToAccount[name];
    }

    function adminDelete() external OnlyAdmin{
        selfdestruct(payable(msg.sender));
    }
}