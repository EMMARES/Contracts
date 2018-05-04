pragma solidity ^ 0.4 .18;
import "./ERC20.sol";
import "./SafeMath.sol";
import "./MiniMeToken.sol";
import "./Whitelist.sol";

contract Crowdsale is Whitelist {
    using SafeMath
    for uint256;
    // The token being sold
    MiniMeToken public token;
    // Address where funds are collected
    address public wallet;
    // How many token units a buyer gets per wei
    uint256 public rate = 6120;
    // Amount of tokens sold
    uint256 public tokensSold;
    //Star of the crowdsale
    uint256 startTime;



    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    event buyx(address buyer, address contractAddr, uint256 amount);

    constructor(address _wallet, MiniMeToken _token, uint256 starttime) public {

        require(_wallet != address(0));
        require(_token != address(0));

        wallet = _wallet;
        token = _token;
        startTime = starttime;
    }

    function setCrowdsale(address _wallet, MiniMeToken _token, uint256 starttime) public {


        require(_wallet != address(0));
        require(_token != address(0));

        wallet = _wallet;
        token = _token;
        startTime = starttime;
    }



    // -----------------------------------------
    // Crowdsale external interface
    // -----------------------------------------
    /**
     *  fallback function ***DO NOT OVERRIDE***
     */
    function() external whenNotPaused payable {
        emit buyx(msg.sender, this, _getTokenAmount(msg.value));
        buyTokens(msg.sender);
    }
    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * @param _beneficiary Address performing the token purchase
     */
    function buyTokens(address _beneficiary) public whenNotPaused payable {

        if ((tokensSold > 20884500000000000000000000) && (tokensSold <= 30791250000000000000000000)) {
            rate = 5967;
        } else if ((tokensSold > 30791250000000000000000000) && (tokensSold <= 39270000000000000000000000)) {
            rate = 5865;
        } else if ((tokensSold > 39270000000000000000000000) && (tokensSold <= 46856250000000000000000000)) {
            rate = 5610;
        } else if ((tokensSold > 46856250000000000000000000) && (tokensSold <= 35700000000000000000000000)) {
            rate = 5355;
        } else if (tokensSold > 35700000000000000000000000) {
            rate = 5100;
        }


        uint256 weiAmount = msg.value;
        uint256 tokens = _getTokenAmount(weiAmount);
        tokensSold = tokensSold.add(tokens);
        _processPurchase(_beneficiary, tokens);
        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
        _updatePurchasingState(_beneficiary, weiAmount);
        _forwardFunds();
        _postValidatePurchase(_beneficiary, weiAmount);
    }

    // -----------------------------------------
    // Internal interface (extensible)
    // -----------------------------------------



    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
        require(_beneficiary != address(0));
        require(_weiAmount != 0);
    }
    /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
        // optional override
    }
    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
     * @param _beneficiary Address performing the token purchase
     * @param _tokenAmount Number of tokens to be emitted
     */
    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
        token.transfer(_beneficiary, _tokenAmount);
    }
    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
     * @param _beneficiary Address receiving the tokens
     * @param _tokenAmount Number of tokens to be purchased
     */
    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
        _deliverTokens(_beneficiary, _tokenAmount);
    }
    /**
     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
     * @param _beneficiary Address receiving the tokens
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
        // optional override
    }
    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param _weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _getTokenAmount(uint256 _weiAmount) internal returns(uint256) {

        return _weiAmount.mul(rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _forwardFunds() internal {
        wallet.transfer(msg.value);
    }

}
