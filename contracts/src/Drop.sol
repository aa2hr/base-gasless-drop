// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Owned} from "solmate/auth/Owned.sol";

/// @title Base gasless drop
/// @notice ERC-721 that can be minted by the owner or a trusted relayer/paymaster.
contract Drop is ERC721, Owned {
    uint256 public immutable maxSupply;
    uint256 public totalMinted;
    uint256 public mintPrice;
    address public relayer;
    string public baseUri;

    error SoldOut();
    error BadPrice();
    error NotRelayer();

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        uint256 mintPrice_,
        string memory baseUri_
    ) ERC721(name_, symbol_) Owned(msg.sender) {
        maxSupply = maxSupply_;
        mintPrice = mintPrice_;
        baseUri = baseUri_;
    }

    function setRelayer(address next) external onlyOwner {
        relayer = next;
    }

    function setMintPrice(uint256 next) external onlyOwner {
        mintPrice = next;
    }

    function setBaseUri(string calldata next) external onlyOwner {
        baseUri = next;
    }

    function mint(address to) external payable returns (uint256 id) {
        if (msg.sender != owner && msg.sender != relayer) revert NotRelayer();
        if (totalMinted >= maxSupply) revert SoldOut();
        if (msg.value != mintPrice) revert BadPrice();
        id = ++totalMinted;
        _safeMint(to, id);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return string.concat(baseUri, _toString(id));
    }

    function _toString(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 t = v;
        uint256 len;
        while (t != 0) {
            len++;
            t /= 10;
        }
        bytes memory b = new bytes(len);
        while (v != 0) {
            len--;
            b[len] = bytes1(uint8(48 + (v % 10)));
            v /= 10;
        }
        return string(b);
    }
}
