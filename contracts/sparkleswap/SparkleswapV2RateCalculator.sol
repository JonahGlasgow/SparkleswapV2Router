pragma solidity =0.6.6; 


import '../libraries/SafeMath.sol';
import '../libraries/Address.sol';
import '../libraries/Ownable.sol';

import '../interfaces/IERC20.sol';



contract SparkleswapV2RateCalculator is Ownable  {
    
  using SafeMath for uint256;
  using SafeMath for uint;
  using Address for address;  
    
  IERC20 private _sparkleswap;
  address public immutable WETH;



IUniswapV2Pair public immutable _IUniswapV2Pair;

  
  //SPARKLESWAP STANDARD BASE RATES
  
  uint256 public gasRate1 = 21000 * (10**9);
  uint256 public gasRate2 = 21000 * (10**9);
  uint256 public gasRate3 = 21000 * (10**9);
  uint256 public gasRate4 = 21000 * (10**9); 
  uint256 public gasRate5 = 21000 * (10**9);
  uint256 public gasRate6 = 21000 * (10**9);
  uint256 public gasRate7 = 21000 * (10**9);
  uint256 public gasRate8 = 21000 * (10**9);
  uint256 public gasRate9 = 21000 * (10**9);
  uint256 public gasRate10 = 21000 * (10**9);
  uint256 public gasRate11 = 21000 * (10**9);
  uint256 public gasRate12 = 21000 * (10**9);
  uint256 public gasRate13 = 21000 * (10**9);
  uint256 public gasRate14 = 21000 * (10**9);
  uint256 public gasRate15 = 21000 * (10**9);
  uint256 public gasRate16 = 21000 * (10**9);
  uint256 public gasRate17 = 21000 * (10**9);
  
  //SPARKLESWAP BASE MULTIPLIER
  
  uint256 public basePercent = 0.500000000000000000 * (10**18); 
  address public adminAddress;
  
  
  constructor(address iUniswapV2Pair, IERC20 sparkleswap, address _WETH) public {
    _IUniswapV2Pair = IUniswapV2Pair(iUniswapV2Pair);
    _sparkleswap = sparkleswap;
    WETH = _WETH;
 }
 
 
 function setAdminAddress (address _admin) external onlyOwner {
   // Set administrator address
   adminAddress = _admin;    
 }
 
   
 function setBasePercent (uint256 _basePercent) external onlyOwner {
   // for simplicity base percent 1 to 99 %
   basePercent = _basePercent * (10**18);    
 }
  
    
 function gettoken0Balance() public view returns (uint) {
    uint token0Balance = _sparkleswap.balanceOf(address(_IUniswapV2Pair));
  return token0Balance;
  }

 function gettoken1Balance() public view returns (uint) {
    uint token1Balance = IERC20(address(WETH)).balanceOf(address(_IUniswapV2Pair));
 return token1Balance;
 }
  
 function getcurrentPrice() public view returns (uint) {
    uint A = gettoken0Balance();
    uint B = gettoken1Balance();
    uint currentPrice = B.mul(10**18).div(A);
 return currentPrice;
 }
 
   //SparkleswapV2RateCalculator LIQUIDITY SECTION -> RATES 
 
  // SparkleSwap -> addLiquidity -> Rate 
 function calculateRebate1 () external view returns (uint256){
    uint256 x = gasRate1.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> addLiquidityETH -> Rate
 function calculateRebate2 () external view returns (uint256){
    uint256 x = gasRate2.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
 // SparkleSwap -> removeLiquidity -> Rate 
 function calculateRebate3 () external view returns (uint256){
    uint256 x = gasRate3.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> removeLiquidityETH -> Rate
 function calculateRebate4 () external view returns (uint256){
    uint256 x = gasRate4.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> removeLiquidityWithPermit -> Rate
 function calculateRebate5 () external view returns (uint256){
    uint256 x = gasRate5.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> removeLiquidityETHWithPermit -> Rate 
 function calculateRebate6 () external view returns (uint256){
    uint256 x = gasRate6.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> removeLiquidityETHSupportingFeeOnTransferTokens -> Rate
 function calculateRebate7 () external view returns (uint256){
    uint256 x = gasRate7.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> removeLiquidityETHWithPermitSupportingFeeOnTransferTokens -> Rate
 function calculateRebate8 () external view returns (uint256){
    uint256 x = gasRate8.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
   //SparkleswapV2RateCalculator SWAP SECTION -> RATES
 
  // SparkleSwap -> swapExactTokensForTokens -> Rate
 function calculateRebate9 () external view returns (uint256){
    uint256 x = gasRate9.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapTokensForExactTokens -> Rate
 function calculateRebate10 () external view returns (uint256){
    uint256 x = gasRate10.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapExactETHForTokens -> Rate
 function calculateRebate11 () external view returns (uint256){
    uint256 x = gasRate11.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapTokensForExactETH -> Rate
 function calculateRebate12 () external view returns (uint256){
    uint256 x = gasRate12.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapExactTokensForETH -> Rate
 function calculateRebate13 () external view returns (uint256){
    uint256 x = gasRate13.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapETHForExactTokens -> Rate
 function calculateRebate14 () external view returns (uint256){
    uint256 x = gasRate14.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapExactTokensForTokensSupportingFeeOnTransferTokens -> Rate
 function calculateRebate15 () external view returns (uint256){
    uint256 x = gasRate15.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapExactETHForTokensSupportingFeeOnTransferTokens -> Rate
 function calculateRebate16 () external view returns (uint256){
    uint256 x = gasRate16.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
  // SparkleSwap -> swapExactTokensForETHSupportingFeeOnTransferTokens -> Rate 
 function calculateRebate17 () external view returns (uint256){
    uint256 x = gasRate17.mul(basePercent);
    uint256 rebateRate = x.mul(10**18).div(getcurrentPrice());
 return rebateRate;
 }
 
 //SparkleswapV2RateCalculator RATE MODIFIER SECTION
 
 function SetBaseRate1 (uint256 _gasLimit , uint256 _Gwei1) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei1 = _Gwei1;
     gasRate1 = Gwei1.mul(_gasLimit); 
 }
 
 function SetBaseRate2 (uint256 _gasLimit , uint256 _Gwei2) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei2 = _Gwei2;
     gasRate2 = Gwei2.mul(_gasLimit); 
 }
 
 function SetBaseRate3 (uint256 _gasLimit , uint256 _Gwei3) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei3 = _Gwei3;
     gasRate3 = Gwei3.mul(_gasLimit); 
 }
 
 function SetBaseRate4 (uint256 _gasLimit , uint256 _Gwei4) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei4 = _Gwei4;
     gasRate4 = Gwei4.mul(_gasLimit); 
 }
 
 function SetBaseRate5 (uint256 _gasLimit , uint256 _Gwei5) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei5 = _Gwei5;
     gasRate5 = Gwei5.mul(_gasLimit); 
 }
 
 function SetBaseRate6 (uint256 _gasLimit , uint256 _Gwei6) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei6 = _Gwei6;
     gasRate6 = Gwei6.mul(_gasLimit); 
 }
 
 function SetBaseRate7 (uint256 _gasLimit , uint256 _Gwei7) onlyOwner external returns (uint256){ 
     uint256 Gwei7 = _Gwei7;
     gasRate7 = Gwei7.mul(_gasLimit); 
 }
 
 function SetBaseRate8 (uint256 _gasLimit , uint256 _Gwei8) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei8 = _Gwei8;
     gasRate8 = Gwei8.mul(_gasLimit); 
 }
 
 function SetBaseRate9 (uint256 _gasLimit , uint256 _Gwei9) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei9 = _Gwei9;
     gasRate9 = Gwei9.mul(_gasLimit); 
 }
 
 function SetBaseRate10 (uint256 _gasLimit , uint256 _Gwei10) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei10 = _Gwei10;
     gasRate10 = Gwei10.mul(_gasLimit); 
 }
 
 function SetBaseRate11 (uint256 _gasLimit , uint256 _Gwei11) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei11 = _Gwei11;
     gasRate11 = Gwei11.mul(_gasLimit); 
 }
 
 function SetBaseRate12 (uint256 _gasLimit , uint256 _Gwei12) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei12 = _Gwei12;
     gasRate12 = Gwei12.mul(_gasLimit); 
 }
 
 function SetBaseRate13 (uint256 _gasLimit , uint256 _Gwei13) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei13 = _Gwei13;
     gasRate13 = Gwei13.mul(_gasLimit); 
 }
 
 function SetBaseRate14 (uint256 _gasLimit , uint256 _Gwei14) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei14 = _Gwei14;
     gasRate14 = Gwei14.mul(_gasLimit); 
 }
 
 function SetBaseRate15 (uint256 _gasLimit , uint256 _Gwei15) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei15 = _Gwei15;
     gasRate15 = Gwei15.mul(_gasLimit); 
 }
 
 function SetBaseRate16 (uint256 _gasLimit , uint256 _Gwei16) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei16 = _Gwei16;
     gasRate16 = Gwei16.mul(_gasLimit); 
 }
 
 function SetBaseRate17 (uint256 _gasLimit , uint256 _Gwei17) external returns (uint256){ 
     require(msg.sender == adminAddress || msg.sender == owner());
     uint256 Gwei17 = _Gwei17;
     gasRate17 = Gwei17.mul(_gasLimit); 
 }
 
}