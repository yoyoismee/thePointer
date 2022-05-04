//SPDX-License-Identifier: MIT
// author : yoyoismee.eth

// ████████╗██╗  ██╗███████╗    ██████╗  ██████╗ ██╗███╗   ██╗████████╗███████╗██████╗
// ╚══██╔══╝██║  ██║██╔════╝    ██╔══██╗██╔═══██╗██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
//    ██║   ███████║█████╗      ██████╔╝██║   ██║██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
//    ██║   ██╔══██║██╔══╝      ██╔═══╝ ██║   ██║██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
//    ██║   ██║  ██║███████╗    ██║     ╚██████╔╝██║██║ ╚████║   ██║   ███████╗██║  ██║
//    ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚═╝      ╚═════╝ ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝

pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ThePointer is ERC721 {
    uint256 lastID;
    mapping(uint256 => address) pointedAddr;
    mapping(uint256 => uint256) pointedTokenID;

    constructor() ERC721("The Pointer", "*") {}

    /// @notice mint a pointer. it's free but feel free to send tip (it's payable)
    /// @param _pointedAddr - address of any ERC721 token you wanna to point to.
    /// @param _pointedTokenID - tokenID of any ERC721 token you wanna to point to.

    function mint(address _pointedAddr, uint256 _pointedTokenID)
        public
        payable
    {
        _mint(msg.sender, lastID + 1);
        pointedAddr[lastID + 1] = _pointedAddr;
        pointedTokenID[lastID + 1] = _pointedTokenID;
        lastID += 1;
    }

    /// @notice update a pointer.
    /// @param tokenID - tokenID of pointer you wanna update
    /// @param _pointedAddr - address of any ERC721 token you wanna to point to.
    /// @param _pointedTokenID - tokenID of any ERC721 token you wanna to point to.

    function update(
        uint256 tokenID,
        address _pointedAddr,
        uint256 _pointedTokenID
    ) public {
        require(ownerOf(tokenID) == msg.sender, "not your token");
        pointedAddr[tokenID] = _pointedAddr;
        pointedTokenID[tokenID] = _pointedTokenID;
    }

    function tokenURI(uint256 tokenID)
        public
        view
        override
        returns (string memory)
    {
        require(ownerOf(tokenID) != address(0), "invalid");
        return ERC721(pointedAddr[tokenID]).tokenURI(pointedTokenID[tokenID]);
    }

    function contractURI() external pure returns (string memory) {
        // string memory json = Base64.encode(
        //     bytes(
        //         string(
        //             abi.encodePacked(
        //                 '{"name": "The Pointer","description": "the Pointer is just a pointer pointing toward what others NFT point at. And It can also recursively point to what others Pointer point to too. aka tokenURI = &pointer.tokenURI.","seller_fee_basis_points": 250,"fee_recipient": "0x6647a7858a0B3846AbD5511e7b797Fc0a0c63a4b"}'
        //             )
        //         )
        //     )
        // );
        // string memory output = string(
        //     abi.encodePacked("data:application/json;base64,", json)
        // );
        // return output;
        // return pre compute result
        return
            "data:application/json;base64,eyJuYW1lIjogIlRoZSBQb2ludGVyIiwiZGVzY3JpcHRpb24iOiAidGhlIFBvaW50ZXIgaXMganVzdCBhIHBvaW50ZXIgcG9pbnRpbmcgdG93YXJkIHdoYXQgb3RoZXJzIE5GVCBwb2ludCBhdC4gQW5kIEl0IGNhbiBhbHNvIHJlY3Vyc2l2ZWx5IHBvaW50IHRvIHdoYXQgb3RoZXJzIFBvaW50ZXIgcG9pbnQgdG8gdG9vLiBha2EgdG9rZW5VUkkgPSAmcG9pbnRlci50b2tlblVSSS4iLCJzZWxsZXJfZmVlX2Jhc2lzX3BvaW50cyI6IDI1MCwiZmVlX3JlY2lwaWVudCI6ICIweDY2NDdhNzg1OGEwQjM4NDZBYkQ1NTExZTdiNzk3RmMwYTBjNjNhNGIifQ==";
    }

    function withdraw() public {
        payable(0x6647a7858a0B3846AbD5511e7b797Fc0a0c63a4b).transfer(
            address(this).balance
        );
    }
}
