//SPDX-License-Identifier: MIT
// author : yoyoismee.eth
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Base64.sol";


contract ThePointer is ERC721 {

    uint lastID;
    mapping(uint => address) pointedAddr;
    mapping(uint => uint) pointedTokenID;
    uint price = 0.001 ether; // simple send tip to me LOL

    constructor() ERC721("The Pointer", "*"){}

    function mint(address _pointedAddr, uint _pointedTokenID) public payable {
        require(msg.value >= price, "invalid payment");

        _mint(msg.sender,lastID +1);
        pointedAddr[lastID +1] = _pointedAddr;
        pointedTokenID[lastID +1] = _pointedTokenID;
        lastID += 1;
    }

    function update(uint tokenID, address _pointedAddr, uint _pointedTokenID) public{
        require(ownerOf(tokenID) == msg.sender, "not your token");
        pointedAddr[tokenID] = _pointedAddr;
        pointedTokenID[tokenID] = _pointedTokenID;
    }

    function tokenURI(uint tokenID) public view override returns(string memory){
        require(ownerOf(tokenID) != address(0), "invalid");
        return ERC721(pointedAddr[tokenID]).tokenURI(pointedTokenID[tokenID]);
    }

        function contractURI() external pure returns (string memory) {
        // string memory json = Base64.encode(
        //     bytes(
        //         string(
        //             abi.encodePacked(
        //                 '{"name": "The Pointer","description": "this token point to another token. you can use this pointer to point to any others NFT.","seller_fee_basis_points": 500,"fee_recipient": "0x6647a7858a0B3846AbD5511e7b797Fc0a0c63a4b"}'
        //             )
        //         )
        //     )
        // );
        // string memory output = string(
        //     abi.encodePacked("data:application/json;base64,", json)
        // );
        // return pre compute result
        return "data:application/json;base64,eyJuYW1lIjogIlRoZSBQb2ludGVyIiwiZGVzY3JpcHRpb24iOiAidGhpcyB0b2tlbiBwb2ludCB0byBhbm90aGVyIHRva2VuLiB5b3UgY2FuIHVzZSB0aGlzIHBvaW50ZXIgdG8gcG9pbnQgdG8gYW55IG90aGVycyBORlQuIiwic2VsbGVyX2ZlZV9iYXNpc19wb2ludHMiOiA1MDAsImZlZV9yZWNpcGllbnQiOiAiMHg2NjQ3YTc4NThhMEIzODQ2QWJENTUxMWU3Yjc5N0ZjMGEwYzYzYTRiIn0=";
    }

    function withdraw() public{
        payable(0x6647a7858a0B3846AbD5511e7b797Fc0a0c63a4b).transfer(address(this).balance);
    }
}
