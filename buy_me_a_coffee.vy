# @version 0.4.0
# @license MIT

interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

@external
@payable
def fund():
    """
    will allow others to send $ with a minimum
    """
    assert msg.value >= as_wei_value(0.0001, "ether"), "More ETH is needed!"

@external
def withdarw():
    pass

@internal
def eth2usd() -> int256:
    """
    address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    abi: 
    """
    price: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
    return price.latestAnswer()

@deploy
def __init__():
    pass