from web3 import Web3
import json, os
from flask import Flask, request


class Server:
    def __init__(self):
        cache = set()
        with open("data.txt", "r") as f:
            for line in f:
                event_id, ticket_id = line.split(",")
                cache.add((event_id, ticket_id))

        INFURA_API_KEY = os.getenv("INFURA_API_KEY")
        web3 = Web3(Web3.HTTPProvider(INFURA_API_KEY))
        with open(
            "../reservation_system/build/contracts/UserController.json", "r"
        ) as f:
            contract_abi = json.load(f)["abi"]
        self.user_controller_contract = web3.eth.contract(
            address="0xC4b8F72Be6Fa9c1f06D26be23770144A543fb504", abi=contract_abi
        )
        app = Flask(__name__)

        # Define a route and a function to handle requests to that route
        @app.route("/")
        def hello():
            return "Hello, World!"

        @app.route("/event", methods=["POST"])
        def invalid_ticket():
            data = request.get_json()
            ticket_id = data.get("ticket_id", "")
            wallet_address = data.get("wallet_address", "")
            event_id = data.get("event_id", "")
            if event_id == "":
                return "No event_id"
            if ticket_id == "":
                return "No ticket_id"
            if wallet_address == "":
                return "No wallet address"
            print(ticket_id, wallet_address, event_id)
            if (event_id, ticket_id) in cache:
                return "Already used"
            result = self.user_controller_contract.functions.get_user_tickets(
                wallet_address
            ).call()
            if ticket_id not in result:
                return "You do not own this ticket"
            cache.add((event_id, ticket_id))
            with open("data.txt", "a") as f:
                f.write(event_id + "," + ticket_id + "\n")

        app.run(debug=True)


# Run the Flask application
if __name__ == "__main__":
    Server()
