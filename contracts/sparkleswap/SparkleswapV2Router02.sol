pragma solidity =0.6.6; 

import '../libraries/SafeMath.sol';
import '../libraries/Address.sol';
import '../libraries/Ownable.sol';

import '../interfaces/IERC20.sol';
import '../interfaces/IWETH.sol';
import '../interfaces/IUniswapV2Factory.sol';
import '../uniswap/UniswapV2Router02.sol';



contract SparkleswapV2Router02 is Ownable {
    
    using SafeMath for uint256;
    using SafeMath for uint;
    using Address for address;
    
IERC20 private _sparkleswap;

    
UniswapV2Router02 public immutable _UniswapV2Router02;
IUniswapV2Pair public immutable _IUniswapV2Pair;
IUniswapV2Factory public immutable _IUniswapV2Factory;

    
uint256 private minBalanceForRebate = 100 * (10**18);
uint256 private basePercent = 50;
address public pairAddress;
address public immutable WETH;

    
constructor(address payable uniswapV2Router02, address iUniswapV2Pair, IERC20 sparkleswap, address _WETH, address iUniswapV2Factory) public {
    _UniswapV2Router02 = UniswapV2Router02(uniswapV2Router02);
    _IUniswapV2Pair = IUniswapV2Pair(iUniswapV2Pair);
    _IUniswapV2Factory = IUniswapV2Factory(iUniswapV2Factory);
    _sparkleswap = sparkleswap;
    WETH = _WETH;
 }
    
 receive() external payable {}   
    
 function setBasePercent (uint256 _basePercent) external onlyOwner {
     basePercent = _basePercent;    
 }
  
// SparkleSwap -> Uniswapv2Pair  - > (Token Price vs Gas fees ) 
    
 function calculateRebate () internal view returns ( uint256 rebateRate){
    uint256 tokenAPrice = _IUniswapV2Pair.price0CumulativeLast();
    uint256 tokenBPrice = _IUniswapV2Pair.price1CumulativeLast();
    uint256 currentPrice = tokenAPrice.div(tokenBPrice).mul(100);
    uint256 x = tx.gasprice.mul(basePercent);
    rebateRate = x.div(currentPrice);
 return rebateRate;
 }
    
// SparkleSwap -> Uniswapv2Router02  - > (Liquidity) 
    
     function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline) external  {
          // Sparkleswap permission         
        require(IERC20(tokenA).approve(address(this), amountADesired), 'approve failed.');
        require(IERC20(tokenB).approve(address(this), amountBDesired), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired), 'transferFrom failed.');
        require(IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(tokenA).approve(address(_UniswapV2Router02), amountADesired), 'approve failed.');
        require(IERC20(tokenB).approve(address(_UniswapV2Router02), amountBDesired), 'approve failed.');     
        _UniswapV2Router02.addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            to,
            deadline);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
       
    }
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline) external payable  {
        _UniswapV2Router02.addLiquidityETH(
            token,
            amountTokenDesired,
            amountTokenMin,
            amountETHMin,
            to,
            deadline);
         // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline) external  {
        // Get Uniswap lp token address
        address UNILP = _IUniswapV2Factory.getPair(tokenA, tokenB);
        // Sparkleswap permission         
        require(IERC20(UNILP).approve(address(this), liquidity), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(UNILP).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(UNILP).approve(address(_UniswapV2Router02), liquidity), 'approve failed.');    
        _UniswapV2Router02.removeLiquidity(
            tokenA,
            tokenB,
            liquidity,
            amountAMin,
            amountBMin,
            to,
            deadline);
          // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
        
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline) external  {
         // Sparkleswap permission         
        require(IERC20(token).approve(address(this), liquidity), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(token).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(token).approve(address(_UniswapV2Router02), liquidity), 'approve failed.');
        _UniswapV2Router02.removeLiquidityETH(
            token,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s) external  {
         // Get Uniswap lp token address
        address UNILP = _IUniswapV2Factory.getPair(tokenA, tokenB);
        // Sparkleswap permission         
        require(IERC20(UNILP).approve(address(this), liquidity), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(UNILP).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(UNILP).approve(address(_UniswapV2Router02), liquidity), 'approve failed.');       
        _UniswapV2Router02.removeLiquidityWithPermit(
            tokenA,
            tokenB,
            liquidity,
            amountAMin,
            amountBMin,
            to,
            deadline,
            approveMax, 
            v, 
            r, 
            s);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s) external  {
        // Sparkleswap permission         
        require(IERC20(token).approve(address(this), liquidity), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(token).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(token).approve(address(_UniswapV2Router02), liquidity), 'approve failed.');    
        _UniswapV2Router02.removeLiquidityETHWithPermit(
            token,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline,
            approveMax, 
            v, 
            r, 
            s);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline) external  {
        // Sparkleswap permission         
        require(IERC20(token).approve(address(this), liquidity), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(token).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(token).approve(address(_UniswapV2Router02), liquidity), 'approve failed.');
        _UniswapV2Router02.removeLiquidityETHSupportingFeeOnTransferTokens(
            token,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s) external {
        // Sparkleswap permission         
        require(IERC20(token).approve(address(this), liquidity), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(token).transferFrom(msg.sender, address(this), liquidity), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(token).approve(address(_UniswapV2Router02), liquidity), 'approve failed.');
        _UniswapV2Router02.removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
            token,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline,
            approveMax, 
            v, 
            r, 
            s);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    // SparkleSwap -> Uniswapv2Router02  - > (Swaps) 
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external  {
        // Sparkleswap permission         
        require(IERC20(path[0]).approve(address(this), amountIn), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(path[0]).approve(address(_UniswapV2Router02), amountIn), 'approve failed.');
        _UniswapV2Router02.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
        
        
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline) external {
         // Sparkleswap permission         
        require(IERC20(path[0]).approve(address(this), amountInMax), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountInMax), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(path[0]).approve(address(_UniswapV2Router02), amountInMax), 'approve failed.');
        _UniswapV2Router02.swapTokensForExactTokens(
            amountOut,
            amountInMax,
            path,
            to,
            deadline);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
        
    function swapExactETHForTokens(
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline) external payable {
        _UniswapV2Router02.swapExactETHForTokens{ value: msg.value }(
            amountOutMin, 
            path, 
            to, 
            deadline);
        //Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
        
        
    function swapTokensForExactETH(
        uint amountOut, 
        uint amountInMax, 
        address[] calldata path, 
        address to, 
        uint deadline) external {
        // Sparkleswap permission         
        require(IERC20(path[0]).approve(address(this), amountInMax), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountInMax), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(path[0]).approve(address(_UniswapV2Router02), amountInMax), 'approve failed.');     
        _UniswapV2Router02.swapTokensForExactETH(
            amountOut, 
            amountInMax, 
            path, 
            to, 
            deadline);
        // Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
        
        
    function swapExactTokensForETH(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline) external {
         // Sparkleswap permission         
        require(IERC20(path[0]).approve(address(this), amountIn), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(path[0]).approve(address(_UniswapV2Router02), amountIn), 'approve failed.');  
        _UniswapV2Router02.swapExactTokensForETH (
            amountIn, 
            amountOutMin, 
            path, 
            to, 
            deadline);
        // Give rebate    
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    
    function swapETHForExactTokens(
        uint amountOut, 
        address[] calldata path, 
        address to, 
        uint deadline) external payable {
        _UniswapV2Router02.swapETHForExactTokens{ value: msg.value }(
            amountOut, 
            path, 
            to, 
            deadline);
        //Give rebate    
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    
  

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external {
         // Sparkleswap permission         
        require(IERC20(path[0]).approve(address(this), amountIn), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(path[0]).approve(address(_UniswapV2Router02), amountIn), 'approve failed.');  
        _UniswapV2Router02.swapExactTokensForTokensSupportingFeeOnTransferTokens (
            amountIn,
            amountOutMin,
            path,
            to,
            deadline);
        //Give rebate
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external payable {
        _UniswapV2Router02.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
            amountOutMin,
            path,
            to,
            deadline);
        //Give rebate        
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
    }
    
    
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external {
         // Sparkleswap permission         
        require(IERC20(path[0]).approve(address(this), amountIn), 'approve failed.');
        // Sparkleswap transfer 
        require(IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
        // Uniswap permission 
        require(IERC20(path[0]).approve(address(_UniswapV2Router02), amountIn), 'approve failed.');  
        _UniswapV2Router02.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline);
        // Give rebate   
        if (_sparkleswap.balanceOf(msg.sender) > minBalanceForRebate ) {
        _sparkleswap.transfer(msg.sender, calculateRebate());
        } 
     
    }
    
    
}