// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SovereignID is ERC721, Ownable {
    uint256 private _tokenIdCounter;

    mapping(address => bool) public hasId;
    mapping(uint256 => bytes32) public identityHash;
    mapping(address => uint256) public reputation;

    event IdentityMinted(address indexed user, uint256 tokenId);
    event ReputationUpdated(address indexed user, uint256 newScore);

    constructor() ERC721("SovereignID", "SID") Ownable() {}

    function mint(bytes32 _identityHash) external {
        require(!hasId[msg.sender], "Identity already exists");

        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter;

        _safeMint(msg.sender, tokenId);

        hasId[msg.sender] = true;
        identityHash[tokenId] = _identityHash;
        reputation[msg.sender] = 1;

        emit IdentityMinted(msg.sender, tokenId);
    }

    // 🔒 Soulbound
    function _transfer(address, address, uint256) internal pure override {
        revert("SovereignID is soulbound");
    }

    function approve(address, uint256) public pure override {
        revert("SovereignID is soulbound");
    }

    function setApprovalForAll(address, bool) public pure override {
        revert("SovereignID is soulbound");
    }

    function hasSovereignId(address user) external view returns (bool) {
        return hasId[user];
    }

    function updateReputation(address user, uint256 newScore) external onlyOwner {
        require(hasId[user], "No Sovereign ID");
        reputation[user] = newScore;
        emit ReputationUpdated(user, newScore);
    }
}
