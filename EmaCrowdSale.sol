pragma solidity ^ 0.4 .18;
import "./EmaToken.sol";
import "./Ownable.sol";
import "./Whitelist.sol";
import "./Crowdsale.sol";

contract EmaCrowdSale is Crowdsale {
    uint256 public hardcap;
    uint256 public starttime;
    Crowdsale public csale;
    using SafeMath for uint256;
    constructor(address wallet, MiniMeToken token, uint256 startTime, uint256 cap) Crowdsale(wallet, token, starttime) public onlyOwner {

        hardcap = cap;
        starttime = startTime;
        setCrowdsale(wallet, token, startTime);
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

    function() external payable onlyWhitelisted whenNotPaused {

        emit buyx(msg.sender, this, _getTokenAmount(msg.value));

        buyTokens(msg.sender);
    }


}
