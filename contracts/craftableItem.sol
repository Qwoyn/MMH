pragma solidity ^0.4.24;

contract ERC20 {
    function totalSupply() public view returns (uint256);
    function balanceOf(address _owner) public view returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
    function approve(address _spender, uint256 _value) public returns (bool);
    function allowance(address _owner, address _spender) public view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ERC1203 is ERC20 {
    function totalSupply(uint256 _class) public view returns (uint256);
    function balanceOf(address _owner, uint256 _class) public view returns (uint256);
    function transfer(address _to, uint256 _class, uint256 _value) public returns (bool);
    function approve(address _spender, uint256 _class, uint256 _value) public returns (bool);
    function allowance(address _owner, address _spender, uint256 _class) public view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _class, uint256 _value) public returns (bool);

    function fullyDilutedTotalSupply() public view returns (uint256);
    function fullyDilutedBalanceOf(address _owner) public view returns (uint256);
    function fullyDilutedAllowance(address _owner, address _spender) public view returns (uint256);
    function convert(uint256 _fromClass, uint256 _toClass, uint256 _value) public returns (bool);

    event Transfer(address indexed _from, address indexed _to, uint256 _class, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _class, uint256 _value);
    event Conversion(uint256 indexed _fromClass, uint256 indexed _toClass, uint256 _value);
}

/**
 * @title ERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface ERC165 {

  /**
   * @notice Query if a contract implements an interface
   * @param _interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool);
}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract ERC721Receiver {
  /**
   * @dev Magic value to be returned upon successful reception of an NFT
   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
   */
  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safetransfer`. This function MAY throw to revert and reject the
   * transfer. Return of other than the magic value MUST result in the 
   * transaction being reverted.
   * Note: the contract address is always the message sender.
   * @param _operator The address which called `safeTransferFrom` function
   * @param _from The address which previously owned the token
   * @param _tokenId The NFT identifier which is being transfered
   * @param _data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes _data
  )
    public
    returns(bytes4);
}

/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param addr address to check
   * @return whether the target address is a contract
   */
  function isContract(address addr) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(addr) }
    return size > 0;
  }

}


/**
 * @title SupportsInterfaceWithLookup
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract SupportsInterfaceWithLookup is ERC165 {
  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
  /**
   * 0x01ffc9a7 ===
   *   bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) internal supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */
  constructor()
    public
  {
    _registerInterface(InterfaceId_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceId];
  }

  /**
   * @dev private method for registering an interface
   */
  function _registerInterface(bytes4 _interfaceId)
    internal
  {
    require(_interfaceId != 0xffffffff);
    supportedInterfaces[_interfaceId] = true;
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

contract CraftableItem is ERC1203, Ownable, ERC165 {
    using SafeMath for uint256;

    enum ShareClass {
        common,
        juniorPreferred, // convertible to 4 common shares per junior preferred shares
        seniorPreferred // convertible to 1.5 junoir preferred shares per senior preferred shares
    }
    uint256 private constant TRADING_SHARE_CLASS = uint256(ShareClass.common);
    uint256 private constant SENIOR_TO_JUNIOR_NUM = 3;
    uint256 private constant SENIOR_TO_JUNIOR_DENOM = 2;
    uint256 private constant JUNIOR_TO_COMMON_NUM = 4;
    uint256 private constant JUNIOR_TO_COMMON_DENOM = 1;

    mapping(uint256 => uint256) private __supplies;
    mapping(address => mapping(uint256 => uint256)) private __balances;
    mapping(address => mapping(address => mapping(uint256 => uint256))) private __allowances;

    constructor() public {
    }

    //ERC-20 functions
    function totalSupply() public view returns (uint256) {
        return totalSupply(TRADING_SHARE_CLASS);
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balanceOf(_owner, TRADING_SHARE_CLASS);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(transfer(_to, TRADING_SHARE_CLASS, _value));

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(approve(_spender, TRADING_SHARE_CLASS, _value));

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowance(_owner, _spender, TRADING_SHARE_CLASS);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(transferFrom(_from, _to, TRADING_SHARE_CLASS, _value));

        emit Transfer(_from, _to, _value);
        return true;
    }

    //ERC1203 functions
    function totalSupply(uint256 _class) public view returns (uint256) {
        return __supplies[_class];
    }

    function balanceOf(address _owner, uint256 _class) public view returns (uint256) {
        return __balances[_owner][_class];
    }

    function transfer(address _to, uint256 _class, uint256 _value) public returns (bool) {
        require(_value <= __balances[msg.sender][_class]);
        
        __balances[msg.sender][_class] = __balances[msg.sender][_class].safeSub(_value);
        __balances[_to][_class] = __balances[_to][_class].safeAdd(_value);

        emit Transfer(msg.sender, _to, _class, _value);
        return true;
    }

    function approve(address _spender, uint256 _class, uint256 _value) public returns (bool) {
        __allowances[msg.sender][_spender][_class] = _value;

        emit Approval(msg.sender, _spender, _class, _value);
        return true;
    }

    function allowance(address _owner, address _spender, uint256 _class) public view returns (uint256) {
        return __allowances[_owner][_spender][_class];
    }

    function transferFrom(address _from, address _to, uint256 _class, uint256 _value) public returns (bool) {
        require(_value <= __balances[_from][_class]);
        require(_value <= __allowances[_from][msg.sender][_class]);
        
        __balances[_from][_class] = __balances[_from][_class].safeSub(_value);
        __balances[_to][_class] = __balances[_to][_class].safeAdd(_value);
        __allowances[_from][msg.sender][_class] = __allowances[_from][msg.sender][_class].safeSub(_value);
        
        emit Transfer(_from, _to, _class, _value);
        return true;        
    }

    function fullyDilutedTotalSupply() public view returns (uint256) {
        uint256 __seniorSupply = __supplies[uint256(ShareClass.seniorPreferred)];
        uint256 __juniorSupply = __supplies[uint256(ShareClass.juniorPreferred)];
        uint256 __commonSupply = __supplies[uint256(ShareClass.common)];

        return fullyDilute(__seniorSupply, __juniorSupply, __commonSupply);
    }

    function fullyDilutedBalanceOf(address _owner) public view returns (uint256) {
        uint256 __seniorBalance = __balances[_owner][uint256(ShareClass.seniorPreferred)];
        uint256 __juniorBalance = __balances[_owner][uint256(ShareClass.juniorPreferred)];
        uint256 __commonBalance = __balances[_owner][uint256(ShareClass.common)];

        return fullyDilute(__seniorBalance, __juniorBalance, __commonBalance);
    }

    function fullyDilutedAllowance(address _owner, address _spender) public view returns (uint256) {
        uint256 __seniorAllowance = __allowances[_owner][_spender][uint256(ShareClass.seniorPreferred)];
        uint256 __juniorAllowance = __allowances[_owner][_spender][uint256(ShareClass.juniorPreferred)];
        uint256 __commonAllowance = __allowances[_owner][_spender][uint256(ShareClass.common)];

        return fullyDilute(__seniorAllowance, __juniorAllowance, __commonAllowance);
    }

    function convert(uint256 _fromClass, uint256 _toClass, uint256 _value) public returns (bool) {
        require(_fromClass > _toClass); //must convert from a superior class
        require(_value <= __balances[msg.sender][_fromClass]);

        uint256 __convertedValue;
        if (_fromClass == uint256(ShareClass.seniorPreferred) && _toClass == uint256(ShareClass.juniorPreferred)) {
            __convertedValue = seniorToJunior(_value);
        } else if (_fromClass == uint256(ShareClass.seniorPreferred) && _toClass == uint256(ShareClass.common)) {
            __convertedValue = juniorToCommon(seniorToJunior(_value));
        } else if (_fromClass == uint256(ShareClass.juniorPreferred) && _toClass == uint256(ShareClass.common)) {
            __convertedValue = juniorToCommon(_value);
        } else {
            revert();
        }

        __balances[msg.sender][_fromClass] = __balances[msg.sender][_fromClass].safeSub(_value);
        __balances[msg.sender][_toClass] = __balances[msg.sender][_toClass].safeAdd(__convertedValue);

        emit Conversion(_fromClass, _toClass, _value);
        return true;
    }

    //Helper functions
    function seniorToJunior(uint256 _value) private pure returns (uint256) {
        return _value.safeMul(SENIOR_TO_JUNIOR_NUM).safeDiv(SENIOR_TO_JUNIOR_DENOM);
    }

    function juniorToCommon(uint256 _value) private pure returns (uint256) {
        return _value.safeMul(JUNIOR_TO_COMMON_NUM).safeDiv(JUNIOR_TO_COMMON_DENOM);
    }

    function fullyDilute(uint256 _seniorValue, uint256 _juniorValue, uint256 _commonValue) private pure returns (uint256) {
        uint256 __juniorDilution = seniorToJunior(_seniorValue);
        uint256 __commonDilution = juniorToCommon(_juniorValue.safeAdd(__juniorDilution));

        return _commonValue.safeAdd(__commonDilution);
    }
}

library SafeMath {
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
}