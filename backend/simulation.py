from dotenv import load_dotenv
from web3_client import Client
import os, time

load_dotenv()
INFURA_API_KEY = os.getenv("INFURA_API_KEY")
WALLET = os.getenv("WALLET")
PRIVATE_KEY = os.getenv("PRIVATE_KEY")

c = Client(INFURA_API_KEY, WALLET, PRIVATE_KEY)
# c.register("jeff")
start = int(time.time())
event = c.create_event(
    "test1",
    "none",
    "no link",
    [1],
    [10**17],
    start,
    start + 45,
    start + 59,
    start + 60,
)
print("create event:", event)
if event == "":
    exit(1)
events = c.list_events()
print("Events:", events)
print("User events:", c.get_user_events())

print("Before register:", c.web3.eth.get_balance(c.wallet_address))
c.register_lottery(event, 10**17)
print("After register:", c.web3.eth.get_balance(c.wallet_address))
# c.cancel_registration(event)
# print("After cancel registration:", c.web3.eth.get_balance(c.wallet_address))
while time.time() <= start + 45:
    time.sleep(1)
c.distribute_ticket(event, 0)
print("User tickets:", c.get_user_tickets())
while time.time() <= start + 60:
    time.sleep(1)
print("Before withdraw:", c.web3.eth.get_balance(c.wallet_address))
c.withdraw_profit(event, WALLET)
print("After withdraw:", c.web3.eth.get_balance(c.wallet_address))
print(c.get_owner(event, 0))
