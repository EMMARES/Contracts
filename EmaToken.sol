pragma solidity ^ 0.4 .18;

import "./Ownable.sol";
import "./Controlled.sol";
import "./TokenController.sol";
import "./MiniMeToken.sol";
contract EmaToken is MiniMeToken {
    constructor(address tokenfactory, address parenttoken, uint parentsnapshot, string tokenname, uint8 dec, string tokensymbol, bool transfersenabled)
    MiniMeToken(tokenfactory, parenttoken, parentsnapshot, tokenname, dec, tokensymbol, transfersenabled) public {}
}
