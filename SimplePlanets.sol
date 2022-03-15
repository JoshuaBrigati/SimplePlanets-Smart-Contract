// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

// import "@1001-digital/erc721-extensions/contracts/RandomlyAssigned.sol";

contract SimplePlanets is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Pausable,
    AccessControl,
    ERC721Burnable,
    VRFConsumerBase
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 private randomResult;
    bool public randomReceived = false;

    mapping(uint256 => address) public creator;
    mapping(uint256 => uint256) private tokenMatrix;
    mapping(uint256 => uint256) dividendAmounts;
    mapping(uint256 => uint256) public mintedTokens;

    uint256 private startFrom;
    string private _baseTokenURI;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 10;
    uint256 public cost = 100000000000000000;
    uint256 public nftNumber;

    address private _admin;

    constructor(string memory baseTokenURI, address admin)
        ERC721("SimplePlanets", "SIMPLEPLANETS")
        VRFConsumerBase(
            0x747973a5A2a4Ae1D3a8fDF5479f1514F65Db9C31, // VRF Coordinator
            0x404460C6A5EdE2D891e8297795264fDe62ADBB75 // LINK Token
        )
    {
        keyHash = 0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c;
        fee = 0.2 * 10**18; // Chainlink oracle fee

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);

        startFrom = 1;

        _baseTokenURI = baseTokenURI;
        _admin = admin;
    }

    function expand(uint256 randomValue) public pure returns (uint256) {
        return uint256(keccak256(abi.encode(randomValue)));
    }

    /**
     * Requests randomness
     */
    function getRandomNumber()
        public
        whenNotPaused
        onlyRole(DEFAULT_ADMIN_ROLE)
        returns (bytes32 requestId)
    {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
        randomReceived = true;
    }

    function mint(uint256 _mintAmount) public payable whenNotPaused {
        require(!paused(), "Contract is paused.");
        require(_mintAmount > 0, "Mint amount must be more than 0.");
        require(
            _mintAmount <= maxMintAmount,
            "Cannot mint more than 10 at a time."
        );
        require(
            tokenCount() + _mintAmount <= maxSupply,
            "Cannot mint more than max supply."
        );

        if (!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
            require(
                msg.value >= cost * _mintAmount,
                "SimplePlanets: must send correct price"
            );
        }

        for (uint256 i = 1; i <= _mintAmount; i++) {
            uint256 id = nextToken();
            _safeMint(msg.sender, id);
            creator[_tokenIdCounter.current()] = msg.sender;
            mintedTokens[_tokenIdCounter.current()] = id;
            splitBalance(msg.value / _mintAmount);

            if (tokenCount() == 100) {
                // Sends 10% of 100 mints.

                nftNumber = expand(randomResult) % 99;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(1000000000000000000);
            }

            if (tokenCount() == 250) {
                // Sends 10% of 150 mints.

                nftNumber = expand(randomResult) % 249;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(1500000000000000000);
            }

            if (tokenCount() == 500) {
                // Sends 10% of 250 mints.

                nftNumber = expand(randomResult) % 499;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(2500000000000000000);
            }

            if (tokenCount() == 1000) {
                // Sends 10% of 500 mints.

                nftNumber = expand(randomResult) % 999;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(5000000000000000000);
            }

            if (tokenCount() == 1750) {
                // Sends 10% of 750 mints.

                nftNumber = expand(randomResult) % 1749;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(7500000000000000000);
            }

            if (tokenCount() == 2750) {
                // Sends 10% of 1000 mints.

                nftNumber = expand(randomResult) % 2749;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(10000000000000000000);
            }

            if (tokenCount() == 4000) {
                // Sends 10% of 1250 mints.

                nftNumber = expand(randomResult) % 3999;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(12500000000000000000);
            }

            if (tokenCount() == 5500) {
                // Sends 10% of 1500 mints.

                nftNumber = expand(randomResult) % 5499;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(15000000000000000000);
            }

            if (tokenCount() == 7500) {
                // Sends 10% of 2000 mints.

                nftNumber = expand(randomResult) % 4499;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(20000000000000000000);
            }

            if (tokenCount() == 10000) {
                // Sends 10% of 2500 mints.

                nftNumber = expand(randomResult) % 9999;
                uint256 tokenNumber = tokenByIndex(nftNumber);

                payable(ownerOf(tokenNumber)).transfer(25000000000000000000);
            }
        }
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SimplePlanets: must have admin role to change base URI"
        );
        _baseTokenURI = baseURI;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SimplePlanets: must have admin role to change token URI"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function setCost(uint256 _newCost) public onlyRole(DEFAULT_ADMIN_ROLE) {
        cost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        maxMintAmount = _newmaxMintAmount;
    }

    function splitBalance(uint256 amount) private {
        uint256 reflectionShare = (amount * 10) / 100; // 10%
        uint256 mintingShare = (amount * 80) / 100; // 80% to creator. Leaves the other 10% for teir giveaway.
        reflectDividend(reflectionShare);
        (bool success, ) = payable(_admin).call{value: mintingShare}("");
        require(success);
    }

    function getReflectionBalance(uint256 tokenId)
        public
        view
        returns (uint256)
    {
        return dividendAmounts[tokenId];
    }

    function getReflectionBalances() public view returns (uint256) {
        uint256 count = balanceOf(msg.sender);
        uint256 total = 0;
        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
            total += getReflectionBalance(tokenId);
        }
        return total;
    }

    function claimRewards() public whenNotPaused {
        uint256 count = balanceOf(_msgSender());
        require(
            count > 0,
            "SimplePlanets: You must have at least 1 Simple Planet to claim rewards"
        );
        uint256 balance = getReflectionBalances();
        payable(msg.sender).transfer(balance);
        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(_msgSender(), i);
            dividendAmounts[tokenId] = 0;
        }
    }

    function claimReward(uint256 tokenId) public whenNotPaused {
        require(
            ownerOf(tokenId) == _msgSender(),
            "SimplePlanets: Only owner can claim rewards"
        );
        uint256 balance = getReflectionBalance(tokenId);
        payable(ownerOf(tokenId)).transfer(balance);
        dividendAmounts[tokenId] = 0;
    }

    function reflectDividend(uint256 amount) private {
        for (uint256 i = 0; i < tokenCount(); i++) {
            uint256 tokenHolder = tokenByIndex(i);
            dividendAmounts[tokenHolder] += amount / tokenCount();
        }
    }

    function withdraw() public payable onlyRole(DEFAULT_ADMIN_ROLE) {
        (bool os, ) = payable(_admin).call{value: address(this).balance}("");
        require(os);
    }

    function checkWithdrawBalance()
        public
        view
        onlyRole(DEFAULT_ADMIN_ROLE)
        returns (uint256)
    {
        return address(this).balance;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Thank you, @1001-digital
    function nextToken() internal ensureAvailability returns (uint256) {
        uint256 maxIndex = totalSupply() - tokenCount();
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    msg.sender,
                    block.coinbase,
                    block.difficulty,
                    block.gaslimit,
                    block.timestamp
                )
            )
        ) % maxIndex;

        uint256 value = 0;
        if (tokenMatrix[random] == 0) {
            // If this matrix position is empty, set the value to the generated random number.
            value = random;
        } else {
            // Otherwise, use the previously stored number from the matrix.
            value = tokenMatrix[random];
        }

        // If the last available tokenID is still unused...
        if (tokenMatrix[maxIndex - 1] == 0) {
            // ...store that ID in the current matrix position.
            tokenMatrix[random] = maxIndex - 1;
        } else {
            // ...otherwise copy over the stored number to the current matrix position.
            tokenMatrix[random] = tokenMatrix[maxIndex - 1];
        }

        // Increment counts
        _tokenIdCounter.increment();

        return value + startFrom;
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
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
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function totalSupply() public view override returns (uint256) {
        return maxSupply;
    }

    function tokenCount() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function availableTokenCount() public view returns (uint256) {
        return totalSupply() - tokenCount();
    }

    modifier ensureAvailability() {
        require(availableTokenCount() > 0, "No more tokens available");
        _;
    }

    modifier ensureAvailabilityFor(uint256 amount) {
        require(
            availableTokenCount() >= amount,
            "Requested number of tokens not available"
        );
        _;
    }
}
