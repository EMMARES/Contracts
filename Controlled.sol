pragma solidity ^ 0.4 .18;
import "./Ownable.sol";
import "./Pausable.sol";

contract Controlled is Pausable {
    /// @notice The address of the controller is the only address that can call
    ///  a function with this modifier
    modifier onlyController {
        require(msg.sender == controller);
        _;
    }
    modifier onlyControllerorOwner {
        require((msg.sender == controller) || (msg.sender == owner));
        _;
    }
    address public controller;
    constructor() public {
        controller = msg.sender;
    }
    /// @notice Changes the controller of the contract
    /// @param _newController The new controller of the contract
    function changeController(address _newController) public onlyControllerorOwner {
        controller = _newController;
    }
}
