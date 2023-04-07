const MyCoin = artifacts.require("MyCoin")
contract("MyCoin",accounts =>{
    it("MyCoinMint",async()=>{
        //部署合约到本地 获取合约实例
       const instance = await  MyCoin.deployed();
       //获取合约名字 用以验证合约是否部署成功
       const name = instance.name.call()
       assert.equal(name,"my coin");


       await instance.mint(100000);
       const account_one_balance = await instance.balanceOf.call(accounts[1]);
       alert.equal(account_one_balance.toNumber(),1100000)
       await instance.burnToken(10000)
       const account_one_balance_1 = await instance.balanceOf.call(accounts[1]);
       alert.equal(account_one_balance_1.toNumber(),1090000)
       await instance.transfer(accounts[1],accounts[3],30000)
       const account_two_balance = await instance.balanceOf.call(accounts[2]);
       const account_three_balance = await instance.balanceOf.call(accounts[3]);
       alert.equal(account_three_balance.toNumber,75)
       alert.equal(account_three_balance.toNumber,30000)
       const nextTokenId = await instance._CUR_TOKENID_.call();
       alert.equal(nextTokenId.toNumber(),4)
    })
})