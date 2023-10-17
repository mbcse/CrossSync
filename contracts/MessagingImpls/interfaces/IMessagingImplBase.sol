// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;


import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol";


import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "../../helpers/ERC2771Recipient.sol";

import "../../interfaces/IMessagingImpl.sol";

abstract contract IMessagingImplBase is IMessagingImpl, Initializable, OwnableUpgradeable, ERC2771Recipient, PausableUpgradeable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, UUPSUpgradeable{

    bytes32 public constant SUPER_ADMIN_ROLE = keccak256("SUPER_ADMIN_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");


    address public crossSyncGatewayAddress;
    address public nativeCurrencyWrappedAddress;
    address public nativeCurrencyAddress;


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function IMessagingImplBase_init(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner) internal onlyInitializing {
        __Pausable_init();
        __Ownable_init();
        __AccessControl_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        IMessagingImplBase_init_unchained(_crossSyncGatewayAddress, _nativeCurrencyWrappedAddress, _nativeCurrencyAddress, _owner);
    }


    function IMessagingImplBase_init_unchained(address _crossSyncGatewayAddress, address _nativeCurrencyWrappedAddress, address _nativeCurrencyAddress, address _owner) internal onlyInitializing {
        __setOwner__(_owner);
        _setRoleAdmin(ADMIN_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(PAUSER_ROLE, SUPER_ADMIN_ROLE);

        crossSyncGatewayAddress = _crossSyncGatewayAddress;
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

    function removeSuperAdmin(address _superAdmin) public onlyOwner {
        _revokeRole(SUPER_ADMIN_ROLE, _superAdmin);
    }

    function removeAdmin(address _admin) public onlySuperAdmin {
        _revokeRole(ADMIN_ROLE, _admin);
    }

    function removePauser(address _pauser) public onlySuperAdmin {
        _revokeRole(PAUSER_ROLE, _pauser);
    } 

    function removeUpgrader(address _upgrader) public onlyOwner {
        _revokeRole(UPGRADER_ROLE, _upgrader);
    }       

/*
************************************************************Contract Modifiers***************************************************
*/



/*
************************************************************ Bridge Action ***************************************************
*/


/*
************************************************************ Rescue Action ***************************************************
*/

    function rescueFunds(
            address token,
            address userAddress,
            uint256 amount
    ) external onlyOwner {
            IERC20Upgradeable(token).transfer(userAddress, amount);
    }

    function rescueEther(address payable userAddress, uint256 amount)
        external
        onlyOwner
    {
        userAddress.transfer(amount);
    }
/*
****************************************** Interface Initilization Functions ****************************************************
*/    

    function setTrustedForwarder(address _newtrustedForwarder) public onlySuperAdmin {
        _setTrustedForwarder(_newtrustedForwarder);
    }

    function setCrossSyncGatewayAddress(address _crossSyncGatewayAddress) public onlySuperAdmin {
        crossSyncGatewayAddress = _crossSyncGatewayAddress;
    }

    function setNativeCurrencyWrappedAddress(address _nativeCurrencyWrappedAddress) public onlySuperAdmin {
        nativeCurrencyWrappedAddress = _nativeCurrencyWrappedAddress;
    }

    function setNativeCurrencyAddress(address _nativeCurrencyAddress) public onlySuperAdmin {
        nativeCurrencyAddress = _nativeCurrencyAddress;
    }

/*
************************************************************** Helper Functions ***********************************************************
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

   receive() external payable {}

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;

}