//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/// @title an standard interface of ERC20
interface ERC20 {
    /// @notice Get the total supply of the token
    /// @return _totalSupply total supply amount
    function totalSupply() external view returns (uint _totalSupply);
    /// @notice Get the token balance of an user
    /// @param _owner address of user who you want to check the balance of
    /// @return balance token balance of an user
    function balanceOf(address _owner) external view returns (uint balance);
    /// @notice Transfer some token of message sender to another address
    /// @param _to the address u want to transfer
    /// @param _value transfer how many tokens
    /// @return success the transfer is successful or not
    function transfer(address _to, uint _value) external returns (bool success);
    /// @notice Transfer some token from one address to another address
    /// @param _from the address u want to transfer from
    /// @param _to the address u want to transfer to
    /// @param _value the value u want to transfer
    /// @return success the transfer is successful or not
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    /// @notice Give a spender the right to transfer your token for a specific amount
    /// @param _spender the spender u want to approve
    /// @param _value the total max value u approve the spender
    /// @return success the approve is successful or not
    function approve(address _spender, uint _value) external returns (bool success);
    /// @notice Check the remained value a owner approve to a spender
    /// @param _owner the owner to check
    /// @param _spender the spender to check
    /// @return remaining remained approved value
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

/// @title an implementation of ERC20
/// @notice a simpe erc20 token for learning, do **not** use it in product!
/// @author lightbird
/// @dev inherit from ERC20 interface and simply implement a token
/// @custom:learning This is an contract for solidity learning.
contract MyToken is ERC20 {
    
    string public constant symbol = "MTK";
    string public constant name = "MyToken";
    uint256 public constant decimals = 18;

    uint256 private constant _totalSupply = 1000000000000000000000;

    mapping (address =>  uint256) private _balanceOf;

    mapping (address => mapping(address => uint256)) private _allowances;

    constructor() {
        _balanceOf[msg.sender] = _totalSupply;
    }

    /// @inheritdoc ERC20
    function totalSupply() public pure override returns (uint256){
        return _totalSupply;
    }

    /// @inheritdoc ERC20
    function balanceOf(address _addr) public view override returns (uint256) {
        return _balanceOf[_addr];
    }

    /// @inheritdoc ERC20
    function transfer(address _to, uint256 _value) public override returns (bool) {
        if(_value > 0 &&  _value <= balanceOf(msg.sender)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value; 
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /// @notice Check whether a address is a contract address or not
    /// @param _addr address
    /// @return is a contract address or not
    /// @dev check the code size of the address is larger than zero or not
    function isContract(address _addr) public view returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;  
    }

    /// @inheritdoc ERC20
    /// @dev check the `to` address is not a contract
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        if(_allowances[_from][msg.sender] > 0 &&
        _value > 0 && 
        _allowances[_from][msg.sender] >= _value &&
        _value <= balanceOf(msg.sender) &&
        !isContract(_to)) {                
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value; 
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /// @inheritdoc ERC20
    /// @dev record allowances in map _allowances
    function approve(address _spender, uint256 _value) external override returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval (msg.sender, _spender, _value);
        return true;
    }

    /// @inheritdoc ERC20
    /// @dev return from map _allowances
    function allowance(address _owner, address _spender) external override view returns (uint256) {
        return _allowances[_owner][_spender];
    }
}