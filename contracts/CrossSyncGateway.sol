// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;
pragma abicoder v2;


import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";


import "./helpers/ERC2771Recipient.sol";
import "./interfaces/ICrossSyncGateway.sol";
import "./interfaces/ICrossSyncReceiver.sol";

import "./interfaces/IMessagingImpl.sol";
import "./interfaces/ICrossSyncReceiverImplementer.sol";



interface IWETH9 {

    function deposit() external payable ;
    function withdraw(uint wad) external payable;
    function totalSupply() external returns (uint);  
    function approve(address guy, uint wad) external returns (bool);

}


contract CrossSyncGateway is ICrossSyncGateway, ICrossSyncReceiver, Initializable, OwnableUpgradeable, ERC2771Recipient, PausableUpgradeable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, EIP712Upgradeable, UUPSUpgradeable {

    bytes32 public constant SUPER_ADMIN_ROLE = keccak256("SUPER_ADMIN_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    address public nativeCurrencyWrappedAddress;
    address public nativeCurrencyAddress;

    struct RouteData {
        address routeAddress;
        bool isValid;
        string routeName;
    }

    mapping (uint256 => RouteData) private routes;
    mapping (uint256 => address) public destChainGatewayAddress;
    mapping (address => uint256) public userNonce;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(string calldata _name, string calldata _version, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner) public initializer {
        __Pausable_init();
        __Ownable_init();
        __AccessControl_init();
        __ReentrancyGuard_init();
        __EIP712_init(_name, _version);
        __UUPSUpgradeable_init();


        __setOwner__(_owner);
        _setRoleAdmin(ADMIN_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(PAUSER_ROLE, SUPER_ADMIN_ROLE);

        nativeCurrencyWrappedAddress = _nativeCurrencyWrappedAddress;
        nativeCurrencyAddress = _nativeCurrencyAddress;
        
    }

/*
******************************************Contract Settings Functions****************************************************
*/

    /**
    * @dev overriding the inherited {transferOwnership} function to reflect the admin changes into the {DEFAULT_ADMIN_ROLE}
    */
    
    function transferOwnership(address newOwner) public override onlyOwner {
        super.transferOwnership(newOwner);
        _grantRole(DEFAULT_ADMIN_ROLE, newOwner);
        renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
    * @dev modifier to check Upgrader rights.
    * contract Owner and Upgrader have Upgrader rights
    */

    modifier onlyUpgrader() {
        require(
            hasRole(UPGRADER_ROLE, _msgSender()) ||
            owner() == _msgSender(),
            "Unauthorized Access");
        _;
    }

    

    /**
    * @dev modifier to check super admin rights.
    * contract owner and super admin have super admin rights
    */

    modifier onlySuperAdmin() {
        require(
            hasRole(SUPER_ADMIN_ROLE, _msgSender()) ||
            owner() == _msgSender(),
            "Unauthorized Access");
        _;
    }

    /**
    * @dev modifier to check admin rights.
    * contract owner, super admin and admins have admin rights
    */
    modifier onlyAdmin() {
        require(
            hasRole(ADMIN_ROLE, _msgSender()) ||
            hasRole(SUPER_ADMIN_ROLE, _msgSender()) ||
            owner() == _msgSender(),
            "Unauthorized Access");
        _;
    }

    /**
    * @dev modifier to check pause rights.
    * contract owner, super admin and pausers's have pause rights
    */
    modifier onlyPauser() {
        require(
            hasRole(PAUSER_ROLE, _msgSender()) ||
            hasRole(SUPER_ADMIN_ROLE, _msgSender()) || 
            owner() == _msgSender(),
            "Unauthorized Access");
        _;
    }

    function pause() public onlyPauser {
        _pause();
    }

    function unpause() public onlyPauser {
        _unpause();
    }

    function addUpgrader(address _upgrader) public onlyOwner {
        _grantRole(UPGRADER_ROLE, _upgrader);
    }

    function addSuperAdmin(address _superAdmin) public onlyOwner {
        _grantRole(SUPER_ADMIN_ROLE, _superAdmin);
    }

    function addAdmin(address _admin) public onlySuperAdmin {
        _grantRole(ADMIN_ROLE, _admin);
    }

    function addPauser(address account) public onlySuperAdmin {
        _grantRole(PAUSER_ROLE, account);
    }

    function removeUpgrader(address _upgrader) public onlyOwner {
        _revokeRole(UPGRADER_ROLE, _upgrader);
    }

    function removeSuperAdmin(address _superAdmin) public onlyOwner {
        _revokeRole(SUPER_ADMIN_ROLE, _superAdmin);
    }

    function removeAdmin(address _admin) public onlySuperAdmin {
        _revokeRole(ADMIN_ROLE, _admin);
    }

    function removePauser(address _pauser) public onlySuperAdmin {
        _revokeRole(PAUSER_ROLE, _pauser);
    }        

/*
************************************************************Setter Functions***************************************************
*/

    function setTrustedForwarder(address _newtrustedForwarder) public onlySuperAdmin {
        _setTrustedForwarder(_newtrustedForwarder);
    }

    function setNativeWrappedCurrencyAddress(address _nativeCurrencyWrappedAddress) public onlySuperAdmin {
        nativeCurrencyWrappedAddress = _nativeCurrencyWrappedAddress;
    }

    function setNativeCurrencyAddress(address _nativeCurrencyAddress) public onlySuperAdmin {
        nativeCurrencyAddress = _nativeCurrencyAddress;
    }

    function getNativeWrappedCurrencyAddress() public view returns (address) {
        return nativeCurrencyWrappedAddress;
    }

    function getNativeCurrencyAddress() public view returns (address) {
        return nativeCurrencyAddress;
    }

    // Setter function for destChainGatewayAddress with onlySuperAdmin modifier
    function setDestChainGatewayAddress(uint256 chainId, address crossSyncGatewayAddress) public onlySuperAdmin {
        destChainGatewayAddress[chainId] = crossSyncGatewayAddress;
    }

/*
************************************************************ Adding Messaging Routes Functions ***************************************************
*/

    function addRoute(uint256 _routeId, address _routeAddress, string memory _routeName) public onlySuperAdmin {
        require(_routeAddress != address(0), "Address 0 Provided");
        require(!routes[_routeId].isValid, "Route Already Exists");
        routes[_routeId] = RouteData(_routeAddress, true, _routeName);
    }

    function removeRoute(uint256 _routeId) public onlySuperAdmin {
        require(routes[_routeId].isValid, "Route Does Not Exist");
        delete routes[_routeId];
    }

    function getRoute(uint256 _routeId) public view returns (address, bool, string memory) {
        return (routes[_routeId].routeAddress, routes[_routeId].isValid, routes[_routeId].routeName);
    }

    function getRouteAddress(uint256 _routeId) public view returns (address) {
        return routes[_routeId].routeAddress;
    }

    function getRouteValidity(uint256 _routeId) public view returns (bool) {
        return routes[_routeId].isValid;
    }

    function getRouteName(uint256 _routeId) public view returns (string memory) {
        return routes[_routeId].routeName;
    }

    function setRouteAddress(uint256 _routeId, address _routeAddress) public onlySuperAdmin {
        require(_routeAddress != address(0), "Address 0 Provided");
        require(routes[_routeId].isValid, "Route Does Not Exist");
        routes[_routeId].routeAddress = _routeAddress;
    }

    function setRouteValidity(uint256 _routeId, bool _isValid) public onlySuperAdmin {
        require(routes[_routeId].isValid, "Route Does Not Exist");
        routes[_routeId].isValid = _isValid;
    }

    function setRouteName(uint256 _routeId, string memory _routeName) public onlySuperAdmin {
        require(routes[_routeId].isValid, "Route Does Not Exist");
        routes[_routeId].routeName = _routeName;
    }

/*
*********************************************************  Events ***********************************************************************
*/    

/*
*********************************************************  Gateway Functions ***********************************************************************
*/    

    function _handleReceive(bytes calldata _payload) internal override {
        IMessagingImpl.ICrossSyncMessagingData memory decodePayload = abi.decode(_payload, (IMessagingImpl.ICrossSyncMessagingData));
        require(decodePayload.destinationChainId == block.chainid, "Destination Chain Id is not same as current chain id");
        require(decodePayload.destinationGatewayAddress == address(this), "Destinatin Gateway Address is not same as current gateway address");
        require(decodePayload.sourceChainId != block.chainid, "Source and Destination Chain Ids are same");
        require(decodePayload.sourceGatewayAddress != address(this), "Source Gateway Address is same as current gateway address");

        ICrossSyncReceiverImplementer(decodePayload.payload.to).receiveMessage(decodePayload.sourceChainId,
            decodePayload.sender,
            decodePayload.payload.data);            
    }

    function sendMessage( uint256 _destinationChainId,
        uint256 _routeId,
        ICrossSyncGateway.MessagingPayload memory _payload,
        bytes calldata _routeData) override public payable {
        require(routes[_routeId].isValid, "Route Does Not Exist");
        require(_payload.to != address(0), "Address 0 Provided");
        require(_destinationChainId != block.chainid, "Source and Destination Chain Ids are same");
        require(destChainGatewayAddress[_destinationChainId] != address(0), "Destination Chain Gateway Address is not set");
        require(msg.value > 0, "Insufficient Relayer(msg.value) Fee Provided");


        IMessagingImpl.ICrossSyncMessagingData memory crossSyncPayload = IMessagingImpl.ICrossSyncMessagingData(
            _msgSender(),
            userNonce[_msgSender()],
            _routeId,
            block.chainid,
            _destinationChainId,
            address(this),
            destChainGatewayAddress[_destinationChainId],
            _payload
        );

        userNonce[_msgSender()] += 1;

        IMessagingImpl messenger = IMessagingImpl(routes[_routeId].routeAddress);
        messenger.executeSendMessage{value: msg.value}(crossSyncPayload);
    }



/*
********************************************************************** ERC20 HELPER FUNCTIONS **********************************************************************
*/

    function _giveTokenApproval(address _spender, address _tokenAddress, uint256 _tokenAmount) internal {
        IERC20Upgradeable token = IERC20Upgradeable(_tokenAddress);
        token.approve(_spender, _tokenAmount); // Approving Spender to use tokens from contract
    }

    function _transferToken(address _from, address _to, address _tokenAddress, uint256 _tokenAmount) internal {
        if(_from == address(this)){
            IERC20Upgradeable transferAsset = IERC20Upgradeable(_tokenAddress);
            transferAsset.transfer(_to, _tokenAmount);
        }else {
            IERC20Upgradeable transferAsset = IERC20Upgradeable(_tokenAddress);
            transferAsset.transferFrom(_from, _to, _tokenAmount);
        }
    }

/*
************************************************************ EIP712, Hashing and Signature Handling ***********************************************
*/

    function _verifyAdmin(bytes32 digest, bytes memory signature) internal view returns (bool) {
        address signer = ECDSAUpgradeable.recover(digest, signature);
        return (hasRole(ADMIN_ROLE, signer));
    }

/*
***************************************** Important Functions - Edit With Care ***********************************************************
*/   
    function _msgSender() internal view virtual override(ContextUpgradeable, ERC2771Recipient) returns (address sender) {
        if (isTrustedForwarder(msg.sender) && msg.data.length >= 20) {
            // The assembly code is more direct than the Solidity version using `abi.decode`.
            /// @solidity memory-safe-assembly
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            return super._msgSender();
        }
    }

    function _msgData() internal view virtual override(ContextUpgradeable, ERC2771Recipient) returns (bytes calldata) {
        if (isTrustedForwarder(msg.sender) && msg.data.length >= 20) {
            return msg.data[:msg.data.length - 20];
        } else {
            return super._msgData();
        }
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyUpgrader
        override
    {}

    function __setOwner__(address _owner) internal {
         super.transferOwnership(_owner);
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);
    }
     
    function supportsInterface(bytes4 interfaceId) public view virtual override(ICrossSyncReceiver, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
   receive() external payable {}

}