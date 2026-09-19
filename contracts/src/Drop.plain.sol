// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// Minimal ERC-721 drop without external libs so `forge test` works before `forge install`.
contract DropPlain {
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event RelayerUpdated(address indexed relayer);

    string public name;
    string public symbol;
    address public owner;
    address public relayer;
    uint256 public immutable maxSupply;
    uint256 public totalMinted;
    uint256 public mintPrice;
    string public baseUri;
    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;

    error SoldOut();
    error BadPrice();
    error NotAuthorized();

    constructor(string memory name_, string memory symbol_, uint256 maxSupply_, uint256 mintPrice_, string memory baseUri_) {
        name = name_;
        symbol = symbol_;
        owner = msg.sender;
        maxSupply = maxSupply_;
        mintPrice = mintPrice_;
        baseUri = baseUri_;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotAuthorized();
        _;
    }

    function setRelayer(address next) external onlyOwner {
        relayer = next;
        emit RelayerUpdated(next);
    }

    function mint(address to) external payable returns (uint256 id) {
        if (msg.sender != owner && msg.sender != relayer) revert NotAuthorized();
        if (totalMinted >= maxSupply) revert SoldOut();
        if (msg.value != mintPrice) revert BadPrice();
        id = ++totalMinted;
        ownerOf[id] = to;
        balanceOf[to] += 1;
        emit Transfer(address(0), to, id);
    }

    function tokenURI(uint256 id) external view returns (string memory) {
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
            b[--len] = bytes1(uint8(48 + (v % 10)));
            v /= 10;
        }
        return string(b);
    }
}
