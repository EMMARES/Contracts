pragma solidity ^0.4.18;
import "./EmaToken.sol";
import "./EmaCrowdSale.sol";
import "./Ownable.sol";

contract Configurator is Ownable {
    EmaToken public token = EmaToken(0xC3EE57Fa8eD253E3F214048879977265967AE745);
    EmaCrowdSale public crowdsale = EmaCrowdSale(0xAd97aF045F815d91621040809F863a5fb070B52d);
    address ownerWallet = 0x3046751e1d843748b4983D7bca58ECF6Ef1e5c77;
    address tokenfactory = 0xB74AA356913316ce49626527AE8543FFf23bB672;
    address fundsWallet = 0x3046751e1d843748b4983D7bca58ECF6Ef1e5c77;
    address incetivesPool = 0x95eac65414a6a650E2c71e3480AeEF0cF76392FA;
    address FoundersAndTeam = 0x88C952c4A8fc156b883318CdA8b4a5279d989391;
    address FuturePartners = 0x5B0333399E0D8F3eF1e5202b4eA4ffDdFD7a0382;
    address Contributors = 0xa02dfB73de485Ebd9d37CbA4583e916F3bA94CeE;
    address BountiesWal = 0xaB662f89A2c6e71BD8c7f754905cAaEC326BcdE7;
    uint256 public crowdSaleStart;


    function deploy() onlyOwner public {
        owner = msg.sender;


        //	crowdsale.transferOwnership(ownerWallet);
        //	token.transferOwnership(ownerWallet);
        //	token.changeController(this);
        token.generateTokens(crowdsale, 255000000000000000000000000); // Generate CrowdSale tokens
        token.generateTokens(incetivesPool, 115000000000000000000000000); //generate Incentives pool tokens
        token.generateTokens(FoundersAndTeam, 85000000000000000000000000); //generate Founders and team tokens
        token.generateTokens(FuturePartners, 40000000000000000000000000); //generate future partners tokens and contributors
        token.generateTokens(BountiesWal, 5000000000000000000000000); //generate contributors tokens
        token.changeController(EmaCrowdSale(crowdsale));
        token.transferOwnership(ownerWallet);
        crowdsale.transferOwnership(ownerWallet);
    }
}
