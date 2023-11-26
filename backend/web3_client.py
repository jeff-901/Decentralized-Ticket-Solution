from web3 import Web3
import json


class Client:
    def __init__(self, INFURA_API_KEY, wallet_address, private_key):
        self.web3 = Web3(Web3.HTTPProvider(INFURA_API_KEY))
        self.wallet_address = wallet_address
        self.private_key = private_key

        with open(
            "../reservation_system/build/contracts/UserController.json", "r"
        ) as f:
            contract_abi = json.load(f)["abi"]
        self.user_controller_contract = self.web3.eth.contract(
            address="0x2ebD628a4A989fFddE3430EEC52E1686c92b2278", abi=contract_abi
        )
        with open(
            "../reservation_system/build/contracts/EventController.json", "r"
        ) as f:
            contract_abi = json.load(f)["abi"]
        self.event_controller_contract = self.web3.eth.contract(
            address="0x637aa26bB37FfC4dfD19b64e81df659229b79C55", abi=contract_abi
        )
        with open("../reservation_system/build/contracts/Event.json", "r") as f:
            self.event_abi = json.load(f)["abi"]

    def register(self, name, gas=10000000):
        transaction = self.user_controller_contract.functions.register(
            name
        ).build_transaction(
            {
                "from": self.wallet_address,
                "gas": gas,
                "gasPrice": self.web3.eth.gas_price,
                "nonce": self.web3.eth.get_transaction_count(self.wallet_address),
            }
        )
        signed_transaction = self.web3.eth.account.sign_transaction(
            transaction, self.private_key
        )
        transaction_hash = self.web3.eth.send_raw_transaction(
            signed_transaction.rawTransaction
        )
        print(f"Transaction sent: {transaction_hash.hex()}")
        self.web3.eth.wait_for_transaction_receipt(transaction_hash)
        # receipt = self.web3.eth.get_transaction_receipt(transaction_hash)

    def get_user_contract_address(self):
        try:
            result = self.user_controller_contract.functions.get_user_contract_address(
                self.wallet_address
            ).call()
            # print(f"User contract address: {result}")
            return result
        except Exception as e:
            print(f"Error calling get_user_contract_address: {e}")

    def get_user_tickets(self):
        try:
            result = self.user_controller_contract.functions.get_user_tickets(
                self.wallet_address
            ).call()
            # print(f"User tickets: {result}")
            return result
        except Exception as e:
            print(f"Error calling get_user_tickets: {e}")

    def get_user_reputation_score(self):
        try:
            result = self.user_controller_contract.functions.get_user_reputation_score(
                self.wallet_address
            ).call()
            # print(f"User reputation score: {result}")
            return result
        except Exception as e:
            print(f"Error calling get_user_reputation_score: {e}")

    def get_user_events(self):
        try:
            result = self.user_controller_contract.functions.get_user_events(
                self.wallet_address
            ).call()
            # print(f"User events: {result}")
            return result
        except Exception as e:
            print(f"Error calling get_user_events: {e}")

    def create_event(
        self,
        name,
        description,
        link,
        seats,
        prices,
        presale_start_time,
        presale_end_time,
        event_start_time,
        event_end_time,
        gas=10000000,
    ):
        transaction = self.event_controller_contract.functions.createEvent(
            name,
            description,
            link,
            seats,
            prices,
            presale_start_time,
            presale_end_time,
            event_start_time,
            event_end_time,
        ).build_transaction(
            {
                "from": self.wallet_address,
                "gas": gas,
                "gasPrice": self.web3.eth.gas_price,
                "nonce": self.web3.eth.get_transaction_count(self.wallet_address),
            }
        )
        signed_transaction = self.web3.eth.account.sign_transaction(
            transaction, self.private_key
        )
        transaction_hash = self.web3.eth.send_raw_transaction(
            signed_transaction.rawTransaction
        )
        print(f"Transaction sent: {transaction_hash.hex()}")
        self.web3.eth.wait_for_transaction_receipt(transaction_hash)
        receipt = self.web3.eth.get_transaction_receipt(transaction_hash)
        if receipt and "status" in receipt:
            if receipt["status"] == 1:
                print("Transaction succeeded!")

                for log in receipt["logs"]:
                    try:
                        event = self.event_controller_contract.events.OnEventCreated().process_log(
                            log
                        )
                    except:
                        pass
                return event["args"][""]
            elif receipt["status"] == 0:
                print("Transaction failed!")
            else:
                print("Unknown transaction status")
        return ""

    def list_events(self):
        try:
            result = self.event_controller_contract.functions.getEvents().call()
            # print(f"Current events: {result}")
            return result
        except Exception as e:
            print(f"Error calling getEvents: {e}")

    def register_lottery(self, event_address, price, gas=10000000):
        event_contract = self.web3.eth.contract(
            address=event_address, abi=self.event_abi
        )
        transaction = event_contract.functions.buy_ticket(price).build_transaction(
            {
                "from": self.wallet_address,
                "value": price,
                "gas": gas,
                "gasPrice": self.web3.eth.gas_price,
                "nonce": self.web3.eth.get_transaction_count(self.wallet_address),
            }
        )
        signed_transaction = self.web3.eth.account.sign_transaction(
            transaction, self.private_key
        )
        transaction_hash = self.web3.eth.send_raw_transaction(
            signed_transaction.rawTransaction
        )
        print(f"Transaction sent: {transaction_hash.hex()}")
        self.web3.eth.wait_for_transaction_receipt(transaction_hash)
        receipt = self.web3.eth.get_transaction_receipt(transaction_hash)
        if receipt and "status" in receipt:
            if receipt["status"] == 1:
                print("Transaction succeeded!")
            elif receipt["status"] == 0:
                print("Transaction failed!")
            else:
                print("Unknown transaction status")

    def cancel_registration(self, event_address, gas=10000000):
        event_contract = self.web3.eth.contract(
            address=event_address, abi=self.event_abi
        )
        transaction = event_contract.functions.cancel_registration().build_transaction(
            {
                "from": self.wallet_address,
                "gas": gas,
                "gasPrice": self.web3.eth.gas_price,
                "nonce": self.web3.eth.get_transaction_count(self.wallet_address),
            }
        )
        signed_transaction = self.web3.eth.account.sign_transaction(
            transaction, self.private_key
        )
        transaction_hash = self.web3.eth.send_raw_transaction(
            signed_transaction.rawTransaction
        )
        print(f"Transaction sent: {transaction_hash.hex()}")
        self.web3.eth.wait_for_transaction_receipt(transaction_hash)

    def withdraw_profit(self, event_address, to_address, gas=10000000):
        event_contract = self.web3.eth.contract(
            address=event_address, abi=self.event_abi
        )
        transaction = event_contract.functions.withdraw(to_address).build_transaction(
            {
                "from": self.wallet_address,
                "gas": gas,
                "gasPrice": self.web3.eth.gas_price,
                "nonce": self.web3.eth.get_transaction_count(self.wallet_address),
            }
        )
        signed_transaction = self.web3.eth.account.sign_transaction(
            transaction, self.private_key
        )
        transaction_hash = self.web3.eth.send_raw_transaction(
            signed_transaction.rawTransaction
        )
        print(f"Transaction sent: {transaction_hash.hex()}")
        self.web3.eth.wait_for_transaction_receipt(transaction_hash)

    def distribute_ticket(self, event_address, seed, gas=10000000):
        event_contract = self.web3.eth.contract(
            address=event_address, abi=self.event_abi
        )
        transaction = event_contract.functions.distribute_ticket(
            seed
        ).build_transaction(
            {
                "from": self.wallet_address,
                "gas": gas,
                "gasPrice": self.web3.eth.gas_price,
                "nonce": self.web3.eth.get_transaction_count(self.wallet_address),
            }
        )
        signed_transaction = self.web3.eth.account.sign_transaction(
            transaction, self.private_key
        )
        transaction_hash = self.web3.eth.send_raw_transaction(
            signed_transaction.rawTransaction
        )
        print(f"Transaction sent: {transaction_hash.hex()}")
        self.web3.eth.wait_for_transaction_receipt(transaction_hash)
        receipt = self.web3.eth.get_transaction_receipt(transaction_hash)
        if receipt and "status" in receipt:
            if receipt["status"] == 1:
                print("Transaction succeeded!")
            elif receipt["status"] == 0:
                print("Transaction failed!")
            else:
                print("Unknown transaction status")

    def get_owner(self, event_address, token_id):
        try:
            event_contract = self.web3.eth.contract(
                address=event_address, abi=self.event_abi
            )
            result = event_contract.functions.getOwner(token_id).call()
            # print(f"Current events: {result}")
            return result
        except Exception as e:
            print(f"Error calling getEvents: {e}")
