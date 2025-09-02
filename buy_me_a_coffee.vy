# @version 0.4.0
# @license MIT

# the contract owner address
owner: address

# to track who fund me
struct Funder:
    funder_address: address
    funder_amount: uint256
funders: public(DynArray[Funder,1000000])

# getting the price from chainlink
price_feed_address: AggregatorV3Interface
interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

@external
@payable
def fund():
    eth_in_usd: uint256 = self._UsdEth(msg.value)
    assert eth_in_usd <= 5 * (10**3), "Minimum $5 required"
    f: Funder = Funder(funder_address=msg.sender, funder_amount=eth_in_usd)
    self.funders.append(f)

@external
def withdarw():
    assert msg.sender == self.owner, "Not the contract owner!"
    send(self.owner, self.balance)
    self.funders = []

@internal
@view
def _UsdEth(eth_amount: uint256) -> uint256:
    # eth_amount: uint256 = 3000000000000000000  # 3 ETH in wei -> USD 13.05
    eth_price: int256 = staticcall self.price_feed_address.latestAnswer()
    eth_price_uint256: uint256 = convert(eth_price, uint256) // (10**8)  # Adjust for 8 decimals
    result: uint256 = (eth_amount * eth_price_uint256) // (10**18)  # Calculate USD equivalent
    return result

@external
@view
def UsdEth(eth_amount: uint256) -> uint256:
    return self._UsdEth(eth_amount)

@deploy
def __init__(price_feed_address: address):
    # 0x694AA1769357215DE4FAC081bf1f309aDC325306 is the price contract
    self.price_feed_address = AggregatorV3Interface(price_feed_address)
    self.owner = msg.sender