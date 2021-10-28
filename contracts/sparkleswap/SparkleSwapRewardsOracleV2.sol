// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.6.6;

// ErrNum:
//  1 - OnlyOwner

contract SparkleSwapRewardsOracleV2 {

    address private _owner;
    uint256 private _rebateTX;
    uint256 private _rebateLP;

    constructor(uint256 _initialTX, uint256 _initialLP) public
    {
        _owner = msg.sender;
        _rebateTX = _initialTX;
        _rebateLP = _initialLP;
    }

    function getRebateTX() 
    external
    view
    returns(uint256)
    {
        return (_rebateTX);
    }
    
    function getRebateLP() 
    external
    view
    returns(uint256)
    {
        return (_rebateLP);
    }

    /**  
     * @dev Set the internal gas rebate to a new value
     * @param _newTX storage slot to update 0 = rebateTX 1 = rebateLP
     * @param _newLP New rebate value
     */
    function setRebate(uint256 _newTX, uint256 _newLP) 
    external
    {
        require(_owner == msg.sender, "1");
        
        _rebateTX = _newTX;
        _rebateLP = _newLP;
        emit RebateUpdated(_rebateTX, _rebateLP);
    }

    /**
     * @dev Event Signal: SparkleSwap Gas Rebate for TXs has been updated
     */
    event RebateUpdated(uint256 _rebateTX, uint256 _rebateLP);
    
}