pragma solidity ^ 0.4 .18;
import "./ERC20.sol";
import "./SafeMath.sol";
import "./MiniMeToken.sol";
import "./Pausable.sol";


/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropiate to concatenate
 * behavior.
 */
contract Crowdsale is Pausable {
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
    uint256 public allCrowdSaleTokens = 255000000000000000000000000; //255M tokens available for crowdsale




    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    event buyx(address buyer, address contractAddr, uint256 amount);

    constructor(address _wallet, MiniMeToken _token) public {

        require(_wallet != address(0));
        require(_token != address(0));

        wallet = _wallet;
        token = _token;

    }

    function setCrowdsale(address _wallet, MiniMeToken _token) internal {


        require(_wallet != address(0));
        require(_token != address(0));

        wallet = _wallet;
        token = _token;

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


        if ((msg.value >= 500000000000000000000) && (msg.value < 1000000000000000000000)) {
            rate = 7140;
        } else if (msg.value >= 1000000000000000000000) {
            rate = 7650;
        } else if (tokensSold <= 21420000000000000000000000) {
            if(rate != 6120) {
            rate = 6120; }
        } else if ((tokensSold > 21420000000000000000000000) && (tokensSold <= 42304500000000000000000000)) {
             if(rate != 5967) {
            rate = 5967; }
        } else if ((tokensSold > 42304500000000000000000000) && (tokensSold <= 73095750000000000000000000)) {
             if(rate != 5865) {
            rate = 5865; }
        } else if ((tokensSold > 73095750000000000000000000) && (tokensSold <= 112365750000000000000000000)) {
             if(rate != 5610) {
            rate = 5610; }
        } else if ((tokensSold > 112365750000000000000000000) && (tokensSold <= 159222000000000000000000000)) {
             if(rate != 5355) {
            rate = 5355; }
        } else if (tokensSold > 159222000000000000000000000) {
             if(rate != 5100) {
            rate = 5100;}
        }


        uint256 weiAmount = msg.value;
        uint256 tokens = _getTokenAmount(weiAmount);

        _processPurchase(_beneficiary, tokens);
        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
        _updatePurchasingState(_beneficiary, weiAmount);
        _forwardFunds();
        _postValidatePurchase(_beneficiary, weiAmount);
        tokensSold = allCrowdSaleTokens.sub(token.balanceOf(this));
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


        if ((_weiAmount >= 500000000000000000000) && (_weiAmount < 1000000000000000000000)) {
            rate = 7140;
        } else if (_weiAmount >= 1000000000000000000000) {
            rate = 7650;
        } else if (tokensSold <= 21420000000000000000000000) {
            if(rate != 6120) {
            rate = 6120; }
        } else if ((tokensSold > 21420000000000000000000000) && (tokensSold <= 42304500000000000000000000)) {
             if(rate != 5967) {
            rate = 5967;}
        } else if ((tokensSold > 42304500000000000000000000) && (tokensSold <= 73095750000000000000000000)) {
             if(rate != 5865) {
            rate = 5865;}
        } else if ((tokensSold > 73095750000000000000000000) && (tokensSold <= 112365750000000000000000000)) {
             if(rate != 5610) {
            rate = 5610;}
        } else if ((tokensSold > 112365750000000000000000000) && (tokensSold <= 159222000000000000000000000)) {
             if(rate != 5355) {
            rate = 5355;}
        } else if (tokensSold > 159222000000000000000000000) {
             if(rate != 5100) {
            rate = 5100;}
        }

        return _weiAmount.mul(rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _forwardFunds() internal {
        wallet.transfer(msg.value);
    }

}
