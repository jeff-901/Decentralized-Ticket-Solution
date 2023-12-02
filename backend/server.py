from web3 import Web3
import json, os, time
from flask import Flask, request


class Server:
    def __init__(self):
        self.cache = set()
        # with open("data.txt", "r") as f:
        #     for line in f:
        #         event_id, token_id = line.strip().split(",")
        #         self.cache.add((event_id, int(token_id)))

        INFURA_API_KEY = os.getenv("INFURA_API_KEY")
        self.web3 = Web3(Web3.HTTPProvider(INFURA_API_KEY))
        with open(
            "../reservation_system/build/contracts/UserController.json", "r"
        ) as f:
            contract_abi = json.load(f)["abi"]
        self.user_controller_contract = self.web3.eth.contract(
            address="0x98a8fC7E90b4F395beBEbEE831eFdffC56089975", abi=contract_abi
        )
        with open("../reservation_system/build/contracts/Event.json", "r") as f:
            self.event_abi = json.load(f)["abi"]
        app = Flask(__name__)

        @app.route("/cache", methods=["GET"])
        def clean():
            self.cache = set()
            return "ok"
        
        @app.route("/event", methods=["POST"])
        def invalid_ticket():
            start = time.time()
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
            if (event_id, token_id) in self.cache:
                return "Already used"
            # print(event_id, token_id)
            # get_user_start = time.time()
            # try:
            #     result = self.user_controller_contract.functions.check_user_tickets(
            #         wallet_address, event_id, token_id
            #     ).call()
            #     print(result)
            #     if not result:
            #         return "You do not own this ticket"
            # except Exception as e:
            #     print(e)
            #     return "You do not own this ticket"
            # print("get user:", time.time() - get_user_start)
            # event_start = time.time()
            try:
                event_contract = self.web3.eth.contract(
                    address=event_id, abi=self.event_abi
                )
                result = event_contract.functions.getOwner(token_id).call()
                if result != wallet_address:
                    return "You do not own this ticket"
            except Exception as e:
                # print("err:", e)
                return "You do not own this ticket"
            # print("get event:",time.time() - event_start)
            # start = time.time()
            self.cache.add((event_id, token_id))
            with open("data.txt", "a") as f:
                f.write(event_id + "," + str(token_id) + "\n")
            # end = time.time()
            # print("write and add cache:", end-start)
            return "Successful"

        app.run(debug=True)


# Run the Flask application
if __name__ == "__main__":
    Server()
