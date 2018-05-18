pragma solidity ^ 0.4 .18;
import "./EmaToken.sol";
import "./Ownable.sol";
import "./Crowdsale.sol";

contract EmaCrowdSale is Crowdsale {


    using SafeMath
    for uint256;
    constructor(address wallet, MiniMeToken token) Crowdsale(wallet, token) public  {

        setCrowdsale(wallet, token);
    }

    function tranferPresaleTokens(address investor, uint256 ammount) public onlyOwner {
        tokensSold = tokensSold.add(ammount);
        token.transferFrom(this, investor, ammount);
    }

    function setTokenTransferState(bool state) public onlyOwner {
        token.changeController(this);
        token.enableTransfers(state);
    }

    function claim(address claimToken) public onlyOwner {
        token.changeController(this);
        token.claimTokens(claimToken);
    }

    function() external payable whenNotPaused {

        emit buyx(msg.sender, this, _getTokenAmount(msg.value));

        buyTokens(msg.sender);
    }


}
