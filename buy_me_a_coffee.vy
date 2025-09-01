# @version 0.4.0
# @license MIT

price_feed_address: AggregatorV3Interface
interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

@external
@payable
def fund():
    eth_in_usd: uint256 = self.UsdEth(msg.value)
    assert eth_in_usd <= 5 * (10**3), "Minimum $5 required"

@external
def withdarw():
    pass

@internal
@view
def UsdEth(eth_amount: uint256) -> uint256:
    # eth_amount: uint256 = 3000000000000000000  # 3 ETH in wei -> USD 13.05
    eth_price: int256 = staticcall self.price_feed_address.latestAnswer()
    eth_price_uint256: uint256 = convert(eth_price, uint256) // (10**8)  # Adjust for 8 decimals
    result: uint256 = (eth_amount * eth_price_uint256) // (10**18)  # Calculate USD equivalent
    return result

@deploy
def __init__(price_feed_address: address):
    # 0x694AA1769357215DE4FAC081bf1f309aDC325306 is the price contract
    self.price_feed_address = AggregatorV3Interface(price_feed_address)
