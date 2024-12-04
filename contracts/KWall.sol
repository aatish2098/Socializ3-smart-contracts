// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // Import Strings library

contract KWall is ERC721, ERC721Burnable, Ownable {
    using Strings for uint256;

    uint256 private _nextTokenId;

    // Mapping from token ID to token URI
    mapping(uint256 => string) private _tokenURIs;

    constructor(address initialOwner)
    ERC721("KWall", "KB9")
    Ownable(initialOwner)
    {}

    // Set base URI (optional if you have a base URI)
    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/"; // Replace with your base CID
    }

    // Mint token with metadata URI
    function safeMint(address to, string memory _tokenURI) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    // Internal function to set the token URI for a given token
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_ownerOf(tokenId) != address(0), "KWall: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    // Override tokenURI to return the per-token URI
    function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
    {
        require(_ownerOf(tokenId) != address(0), "KWall: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If both base URI and token URI are set, concatenate them
        if (bytes(base).length > 0 && bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
            // If only token URI is set, return it
        else if (bytes(_tokenURI).length > 0) {
            return _tokenURI;
        }
            // If only base URI is set, concatenate token ID
        else if (bytes(base).length > 0) {
            return string(abi.encodePacked(base, tokenId.toString()));
        }
            // If neither is set, return empty string
        else {
            return "";
        }
    }

    // Override burn to clear metadata in storage
    function burn(uint256 tokenId) public override {
        require(
            _isAuthorized(owner(),_msgSender(),tokenId),
            "KWall: caller is not token owner nor approved"
        );

        // Call the parent burn function
        super.burn(tokenId);

        // Clear metadata (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }

    // Withdraw contract balance (owner only)
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "KWall: No funds to withdraw");
        payable(owner()).transfer(balance);
    }

    // Getter for the next token ID
    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }
}
