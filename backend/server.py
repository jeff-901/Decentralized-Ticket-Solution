from web3 import Web3
import json, os
from flask import Flask, request


class Server:
    def __init__(self):
        cache = set()
        with open("data.txt", "r") as f:
            for line in f:
                event_id, token_id = line.strip().split(",")
                cache.add((event_id, int(token_id)))

        INFURA_API_KEY = os.getenv("INFURA_API_KEY")
        self.web3 = Web3(Web3.HTTPProvider(INFURA_API_KEY))
        with open(
            "../reservation_system/build/contracts/UserController.json", "r"
        ) as f:
            contract_abi = json.load(f)["abi"]
        self.user_controller_contract = self.web3.eth.contract(
            address="0x2ebD628a4A989fFddE3430EEC52E1686c92b2278", abi=contract_abi
        )
        with open("../reservation_system/build/contracts/Event.json", "r") as f:
            self.event_abi = json.load(f)["abi"]
        app = Flask(__name__)

        # Define a route and a function to handle requests to that route
        @app.route("/")
        def hello():
            return "Hello, World!"

        @app.route("/event", methods=["POST"])
        def invalid_ticket():
            data = request.get_json()
            token_id = data.get("token_id", "")
            wallet_address = data.get("wallet_address", "")
            event_id = data.get("event_id", "")
            if event_id == "":
                return "No event_id"
            if token_id == "":
                return "No token_id"
            if wallet_address == "":
                return "No wallet address"
            if (event_id, token_id) in cache:
                return "Already used"
            # result = self.user_controller_contract.functions.get_user_tickets(
            #     wallet_address
            # ).call()
            # print(result)
            # if (event_id, token_id) not in result:
                # return "You do not own this ticket"
            event_contract = self.web3.eth.contract(
                address=event_id, abi=self.event_abi
            )
            try:
                result = event_contract.functions.getOwner(token_id).call()
                print(result)
                if result != wallet_address:
                    return "You do not own this ticket"
            except Exception as e:
                print(e)
                return "err"
            cache.add((event_id, token_id))
            with open("data.txt", "a") as f:
                f.write(event_id + "," + str(token_id) + "\n")
            return "Successful"

        app.run(debug=True)


# Run the Flask application
if __name__ == "__main__":
    Server()
