// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
//个人操作平台
contract WeiboAccount {
        //数量
    uint _numberOfWebbos;
    //账户，所有者
    address _adminAddress;
    //构造函数
    constructor() {
       _numberOfWebbos=0;
       _adminAddress = msg.sender; 
    }
    struct _weibo{
        string content;
        uint timestamp;
    }

    //通过ID查找微博
    mapping(uint => _weibo) _mapWeibo;
    //修改器
    modifier onlyAdminAccount {
        require(_adminAddress == msg.sender,"Not an owner;");
        _;
    }
    //发送微博
    function sendWebbo(string memory _content) external { 
        require(bytes(_content).length <= 160 && bytes(_content).length != 0);
        _mapWeibo[_numberOfWebbos].timestamp = block.timestamp;
        _mapWeibo[_numberOfWebbos].content = _content;
        _numberOfWebbos++;
    }
    //查看最新微博 先不返回json
    function getLatestWeibo()external  view returns (uint timestamp, string memory content){
        timestamp = _mapWeibo[_numberOfWebbos-1].timestamp;
        content = _mapWeibo[_numberOfWebbos-1].content;
    }
    //根据ID查找微博内容
    function getContentOfId(uint id) external view returns (uint timestamp,string memory content){
       timestamp = _mapWeibo[id].timestamp;
        content = _mapWeibo[id].content; 
    }
    //获取发送微博总数
    function getWeiboAccount() external view returns(uint ){
       return  _numberOfWebbos - 1;
    }
    //微博账户所有者
    function getWeiboOwner() external view returns (address){
        return _adminAddress;
    }
    //销毁合约
    function adminDeleteAccount() public onlyAdminAccount{
        // selfdestruct(msg.sender);
        // selfdestruct(payable(msg.sender));
        sendAll(msg.sender);

    }
}