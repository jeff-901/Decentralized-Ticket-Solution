from dotenv import load_dotenv
from web3_client import Client
import os, time
load_dotenv()
INFURA_API_KEY = os.getenv("INFURA_API_KEY")
WALLET = os.getenv("WALLET")
PRIVATE_KEY = os.getenv("PRIVATE_KEY")

c = Client(INFURA_API_KEY, WALLET, PRIVATE_KEY)
c.register("jeff")
event = c.create_event(
    "test1",
    "none",
    "no link",
    [100],
    [10**17],
    int(time.time()),
    int(time.time() + 3600 * 24),
    int(time.time() + 3600 * 24 * 10),
    int(time.time() + 3600 * 24 * 10 + 3600),
)
print("create event:", event)
events = c.list_events()
print("Events:", events)
print("User events:", c.get_user_events())
print("User tickets:", c.get_user_tickets())
print("Before register:", c.web3.eth.get_balance(c.wallet_address))
c.register_lottery(event, 10**17)
print("After register:", c.web3.eth.get_balance(c.wallet_address))
c.cancel_registration(event)
print("After cancel registration:", c.web3.eth.get_balance(c.wallet_address))