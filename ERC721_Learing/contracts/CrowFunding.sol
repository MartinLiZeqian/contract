//创建不同的募资活动 用来募集以太坊
//记录相应活动下的募资具体信息(参与人数，募集的以太坊数量)，以及记录参数的用户地址以及投入的数量
//业务逻辑(1.用户参与，2.添加新的募集活动，3.活动结束后进行资金领取)
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
//存储抽离成了一个合约
contract CrowFundingStorage{
        //活动
    struct Compaign{
        address payable receiver;
        uint numFunder;
        uint fundingGoal;
        uint totalAmount;
    }
     //参与人
    struct Funder{
        address addr;
        uint amount;
    }
    //活动数量
    uint public numCampagins;
    mapping(uint => Compaign) compaigns;
    mapping(uint => Funder[]) funders;
    //是否已经参与过某个活动
    mapping(uint => mapping(address=>bool)) public isParticipate;
    //函数执行 前进行预制检查
    modifier judgeParticipate(uint campainID){
        //通过后
        require(isParticipate[campainID][msg.sender] == false);
        //代表通过检查后执行下面函数的内容
        _; 
    }
}
//合约继承是可以多继承的
contract CrowFunding is CrowFundingStorage{
    //只有合约拥有者才可以创建募资活动
    address immutable onwer;
    constructor(){
        onwer = msg.sender;
    }

   
    //合约部署人
    modifier isOwner(){
        require(msg.sender == onwer);
        _;
    }
    //可以创建新的募资活动
    function newCampagins(address payable receiver,uint goal)external  isOwner() returns(uint compaignID){
        compaignID = numCampagins++;
        //这样拿到的是一个默认的空的campain 这样就可以把新建的写入mapping里了
       Compaign storage c = compaigns[compaignID];
        c.receiver = receiver;
        c.fundingGoal = goal;

    }
    // //查询存募资活动列表
    // function getCampaginList() external view returns( Compaign[] memory){

    //     return compaigns;
    // }
    //  //根据campainID查询存募资活动
    // function getCampagin(uint campainID) external view returns( Compaign  memory){
    //     return  compaigns[campainID];
    // }
    //查询合约募集的金额
    function getCampaginAmount(uint campainID) external view returns(uint amount){
        amount = compaigns[campainID].totalAmount;

    }
    //参与募资 judgeParticipate进行了预制检查 当用户已经参与过该活动后就不让其继续参加
    function bid(uint compaignID) external payable judgeParticipate(compaignID){
        Compaign storage c = compaigns[compaignID];
        c.totalAmount +=msg.value;
        c.numFunder +=1;
        //募集人加入募集者数组mapping
         funders[compaignID].push(Funder({
             addr:msg.sender,
             amount:msg.value
         }));
         isParticipate[compaignID][msg.sender] = true;
    }
    //如果达到了 才可以领取
    function withDraw(uint compaignID) external returns (bool reached){
        Compaign storage c = compaigns[compaignID];
        //如果募集到的金额还不够 不可以提取
        if(c.totalAmount<c.fundingGoal){
            return false;
        }
        uint amount = c.totalAmount;
        c.totalAmount = 0;
        //提取到地址
        c.receiver.transfer(amount);
        return true;
    }
}