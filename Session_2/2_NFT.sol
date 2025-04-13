// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/*
The contract extends the ERC721 contracts to create a digital certificate.
To each token, a reference id is assigned, representing an external identifier
of the certificate.
*/
contract DigitalCertificates is
    ERC721,
    ERC721URIStorage
{
    // Base URI for the whole collection
    string private baseURI; 

    // Mapping of tokenId to reference id (external identifier)
    mapping(uint256 tokenId => string) private refIds;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_
    ) ERC721(name_, symbol_) {
        /*stores some parameters. 
           baseURI is the base URI for the whole collection.
        */
        baseURI = baseURI_;
    }

    // Returns the base URI for the whole collection
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // Sets the base URI for the whole collection
    function setBaseURI(string memory baseURI_) public onlyRole(TOKEN_MANAGER) {
        baseURI = baseURI_;
    }

    // Mint a new certificate given a reference id and a URI
    function mint(
        address to,
        uint256 tokenId,
        string memory refId,
        string memory uri
    ) public {
        _setTokenURI(tokenId, uri); // call the ERC721URIStorage function
        _safeMint(to, tokenId); // call the ERC721 function
        refIds[tokenId] = refId; // store the reference id
    }

    // The following functions are overrides required by Solidity.
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal 
      override(ERC721, ERC721Enumerable)
      returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}