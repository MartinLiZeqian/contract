
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract MintableERC721 is ERC721,ERC721URIStorage,Ownable{
    //通过合约的owner 去mint新的NFT,可以指定NFT的接收者地址，以及设置nft对应的tokenId和uri
    uint256 public _CUR_TOKENID_;
    constructor(string memory _name,string memory _symbol) ERC721(_name,_symbol){}

    function mint(address[] calldata receives,string[] calldata uris) external onlyOwner {
        require(receives.length == uris.length,"PARAMS_NOT_MATCH");
        for(uint256 i= 0;i<receives.length;i++){
            //开始mint
            _safeMint(receives[i], _CUR_TOKENID_);
            _setTokenURI(_CUR_TOKENID_, uris[i]);
            _CUR_TOKENID_ = _CUR_TOKENID_+1;

        }
    }
    function _burn(uint256 tokenId) internal override (ERC721,ERC721URIStorage){
        super._burn(tokenId);
    }
    function tokenURI(uint256 tokenId) public view override (ERC721,ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }
}