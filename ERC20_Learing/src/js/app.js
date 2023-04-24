var web3;
var chainId;
var accountAddress;

var erc20Abi=
async function connect() {
    //获取web3的实例
    if (window.ethereum) {
        try {
            //唤起用户同意
         await window.ethereum.enable(); 
         web3 = new Web3(window.ethereum)
         } catch (error) {
           //用户取消链接  
         }
    //旧浏览器可以通过这种方式拿到 
    }else if(window.web3){
        web3 = new Web3(window.web3)
    }else{
        alert("please install wallet")
    }
    
   chainId = await web3.eth.getChainId();
    var blochNumber = await web3.eth.getBlockNumber();
    var block = await web3.eth.getBlock(blochNumber);
    var blockTimestamp = block.timestamp;
    var account = await web3.eth.getAccounts();
    accountAddress = account[0]
    var balance = await web3.eth.getBalance(accountAddress);

    //渲染到页面上
    document.getElementById("chain_id").innerText = chainId;
    document.getElementById("block_number").innerText = blochNumber;
    document.getElementById("block_timestamp").innerText = blockTimestamp;
    document.getElementById("account_address").innerText = accountAddress;
    document.getElementById("account_balance").innerText = web3.utils.fromWei(balance);
}

 //读取合约
async function readContract(params) {
    var contractAddress = document.getElementById("contract_address").value;
    //获取合约需要合约地址和合约abi
    var instance = web3.eth.Contract(contractAddress,erc20Abi);
    //调用合约中的symbol 方法 读取到数据
  var tokenSymbol = await  instance.methods.symbol().call();
  var tokenTotalSupply = await  instance.methods.totalSupply().call();

  //读取合约余额
  var balance = await instance.methods.balanceOf(accountAddress).call();

}

async function transfer() {

    var contractAddress = document.getElementById("contract_address").value;
    var instance = web3.eth.Contract(contractAddress,erc20Abi);
    // var fromAddress = document.getElementById("from_address").value;
    var toAddress = document.getElementById("to_address").value;
    var amount = document.getElementById("transfer_amount").value;
    //调用合约进行交易
    //1.构造data
    //web3.utils.toWei(amount) 将用户传入的数据转化成带18个零的decimal类型
    //.encodeABI() 这个包装的data要符合ABI编码规范
    var transferData = instance.methods.transfer(toAddress,web3.utils.toWei(amount)).encodeABI()
    //2.预执行一下看看消耗多少gas 同时也可以看到交易是否可以被成功执行 避免gas浪费
    var estimateGasRes = await web3.eth.estimateGas({
        to:contractAddress,//这里的to 是合约地址  与合约交互
        data:transferData,
        from:accountAddress,
        value:'0x0'//不交易eth 所以填0
    })
    //获取当前gasprice
    var gasPrice = await web3.eth.getGasPrice();
    //该账户的交易nonce
    let nonce = await web3.eth.getTransactionCount(accountAddress);

    //要交易的数据组装
    let rawTransaction = {
        from:accountAddress,
        to:contractAddress,
        nonce:web3.utils.toHex(nonce),
        gasPrice:gasPrice,
        gas:estimateGasRes*2,//预留一部分额度 担心预估的gas不够交易
        value:'0x0',
        data:transferData,
        chainId:chainId,
    }
    //进行交易签名 和 发起交易
    web3.eth.sendTransaction(rawTransaction).on("transactionHash",function (hash) {
        //监听交易的回调
        console.log("txHash",hash);
    })

}