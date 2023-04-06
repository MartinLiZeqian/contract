const MintableERC721 = artifacts.require("MintableERC721")
contract("MintableERC721",accounts =>{
    // 测试MintNFT 功能是否正常
    it("MintNFT",async()=>{
        //部署合约到本地 获取合约实例
       const instance = await  MintableERC721.deployed();
       //获取合约名字 用以验证合约是否部署成功
       const name = instance.name.call()
       assert.equal(name,"Mintable NFT");
       let receivers=[
        accounts[1],
        accounts[1],
        accounts[2],
        accounts[3],

       ]
       let uris=[
        'https://gimg3.baidu.com/search/src=http%3A%2F%2Fpics0.baidu.com%2Ffeed%2Fcefc1e178a82b9011cb05abd7c1a5b7c3812ef46.jpeg%40f_auto%3Ftoken%3Db50ebb7c2b148b828d2a8b550df76629&refer=http%3A%2F%2Fwww.baidu.com&app=2021&size=f360,240&n=0&g=0n&q=75&fmt=auto?sec=1680368400&t=7a6856c59f0749a8a3529de5153d2b64',
        'https://gimg3.baidu.com/search/src=http%3A%2F%2Fpics0.baidu.com%2Ffeed%2Fcefc1e178a82b9011cb05abd7c1a5b7c3812ef46.jpeg%40f_auto%3Ftoken%3Db50ebb7c2b148b828d2a8b550df76629&refer=http%3A%2F%2Fwww.baidu.com&app=2021&size=f360,240&n=0&g=0n&q=75&fmt=auto?sec=1680368400&t=7a6856c59f0749a8a3529de5153d2b64',
        'https://gimg3.baidu.com/search/src=http%3A%2F%2Fpics0.baidu.com%2Ffeed%2Fcefc1e178a82b9011cb05abd7c1a5b7c3812ef46.jpeg%40f_auto%3Ftoken%3Db50ebb7c2b148b828d2a8b550df76629&refer=http%3A%2F%2Fwww.baidu.com&app=2021&size=f360,240&n=0&g=0n&q=75&fmt=auto?sec=1680368400&t=7a6856c59f0749a8a3529de5153d2b64',
        'https://gimg3.baidu.com/search/src=http%3A%2F%2Fpics0.baidu.com%2Ffeed%2Fcefc1e178a82b9011cb05abd7c1a5b7c3812ef46.jpeg%40f_auto%3Ftoken%3Db50ebb7c2b148b828d2a8b550df76629&refer=http%3A%2F%2Fwww.baidu.com&app=2021&size=f360,240&n=0&g=0n&q=75&fmt=auto?sec=1680368400&t=7a6856c59f0749a8a3529de5153d2b64',
       ]
       await instance.mint(users,uris);
       const account_one_balance = await instance.balanceOf.call(receivers[1]);
       alert.equal(account_one_balance.toNumber(),2)
       const owner_of_two = await instance.ownerOf.call(2);
       alert.equal(owner_of_two,receivers[2])
       const nextTokenId = await instance._CUR_TOKENID_.call();
       alert.equal(nextTokenId.toNumber(),4)
    })
})