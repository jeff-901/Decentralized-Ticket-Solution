import requests, json, time, os, signal, sys
import threading, random


def f1(address):
    res = requests.post(
        "http://127.0.0.1:5000/event",
        headers={"Content-Type": "application/json"},
        data=json.dumps(
            {
                "token_id": 0,
                "event_id": address,
                "wallet_address": "0x9191daAaaAE3a2f4d32fc97e455611eD59704000",
            }
        ),
    )


def f3(id):
    res = requests.post(
        "http://127.0.0.1:5000/event",
        headers={"Content-Type": "application/json"},
        data=json.dumps(
            {
                "token_id": id,
                "event_id": "0x6aC7657671dE6D2973BE5C3659825A750ebC1459",
                "wallet_address": "0x9191daAaaAE3a2f4d32fc97e455611eD59704000",
            }
        ),
    )


addresses = [
    "0x6aC7657671dE6D2973BE5C3659825A750ebC1459",
    "0x7577cee030b266b2C083Fc525dF9461521A3Bd2B",
    "0x3a0557d06fc4b6F097E061D4E4AcAF6268C76446",
    "0xa6F9456a7e48feF75974A06F62dAe5798Fb94fa8",
    "0x935f5f85f7C8b3923B7d1fC315b03908EEE3B562",
    "0x25BBC31507edfbc7d975Fac2DC2C54f27eF0dB50",
    "0xaE09D06f10A520dFfFB601d3209D1Fc6fD02aa43",
    "0xe7202E475D05b60ddEa827171E75d7a5A90DBdbd",
    "0x225eb67910214980D9448bEAA8488b9E359a693f",
    "0x2b5860eD626fB5A22156252550E8F738D4c50795",
    "0x0532593E302B1bA6b5F5aec050004B2242Bf7c86",
    "0xD59C3AA4B2FBD586FAeCEb59FcA369b66c62f0c3",
    "0x5C3DE9Db5d12c593f10e16E593636f377590B639",
    "0xDB00E284da512C2C41Bf1733aD82833584623CDc",
    "0x85f5DaE4c177d1caA6C01296E4513b1091C37a68",
    "0xEd62396db916C5fb6efC54f4A5c826d93DBC03c8",
    "0xeBC390D2Ed778d7fe3109D46EB62a108435A9AFb",
    "0xa0B691Cc262E0cA3B7093D85656611f758f47Bf8",
    "0xf72283298BFf722D2DDd65D8050d67a8d00b3B87",
    "0x27675e9C6Ceab8d81cb33876e16F9CAA7C52Ff5a",
    "0x584CEf93866c87868121C872d2fcB57E703c32be",
    "0xaFdDBAf3031B392D9f7EBc932D95b6f488912D09",
    "0x76C4f16700c7B6b5d2127764130394E635FcF96F",
    "0x29c274d266AF1452779732eDEF264173eddCC2c8",
    "0x59aC2eca922AC41BC2b5FeCf2DA102FC0e9DAac6",
    "0x9044F9935D21239B6DB99bd392Ee7CeE2175d78d",
    "0x36DCB5a6cFab0dB915b1f5A451e7df64b1052A39",
    "0xe22e93aDE6B3240eF41425b43b9feabF8C03930A",
    "0xC489540829d396A11540EA7806497037F2Ef554a",
    "0xf0d448f30B5183AC7f7A26874eeBCD6409709cd0",
    "0xb918915F914F169194e08621d5E94E7D2d3A8687",
    "0xa6d20b0aC63c0130a19B685C620C9542d27EfaA6",
    "0xa176Ab47973BAef3A172C646cD4036E2fDB5Fdf5",
    "0x78e28e2a6AD99EDd3971946a7aCF6ea65Ff7507B",
    "0xf3046Ed4665DEE6DBa9417C3f04630B9fae5AaEA",
    "0x5e557D3689D56F3C81C39D7E347Ab9B12835cAF3",
    "0xf01755101679Db8D6ACBDe02CFA14945027CF029",
    "0xAACE49Ee4FBF92fBD958F0Def6548A25B6786ee3",
    "0xe4E667D75e7f0904EF80303F5e840886560Cf408",
    "0xbB9AC043eB11a81Ae02b94742C326de2374e4a25",
    "0x672Cd5215b12Ec55a69e2b5136284cd4723E8f89",
    "0x1dd47e682686A8E9Fe60727F4943942445998845",
    "0xfA44661f6A80ecaF1097404DA309F43a4285C270",
    "0xA1A532650d4a04a348C69771925869eEf2F95112",
    "0x3A5f0bA4bC68BD8a1029AEe2dFB7D89165Acd473",
    "0x3096Ed5a467C2Eee5d45820012E08584636bafa2",
    "0xDE515A3bEB62586CeAd901c5B9fc7c359cDc5152",
    "0x3633f008483f02eb66a193b8d4086410EbFa6d79",
    "0x506a398a84f691962eB1390CE1f8ec2C4A25F424",
    "0x980490628a73B609f1D1c9FB03cCB5bcc1e704Ab",
    "0xE55dDa751d5044F4a1d3a8767a2F988321BedfB9",
    "0xFB4EeF414317B6c5C0Ab93d2247C21C79e18DBE7",
    "0x9B6378c92F2E32f3d78035bDdd04cd92Af5487E4",
    "0x8877D60Af79e31d21E75e434De1009797bb5EB22",
    "0xdce44d34BeF68E7A03f603896eA6daa82BB23e29",
    "0x7D95bD64fD1Cf4F5FCb72Ceb10fDAFAD9941b46a",
    "0x64e6d647105aCbCa714C17280cA50dcFcdAD645c",
    "0x30fC37789fA1AaC0eB73061Cd3F6eeE6C64Df03D",
    "0x499A8eB2dc1E63f7Fc7150d4B714631Bb357AB66",
    "0xAb6EfF02c117a72EFab7b89FDbe8CA400cE622dF",
    "0xD12A912e6aA0185D91506936146b3410551eAe59",
    "0xe9749B222e7Fe98dDfA36E69E557Dd04cD782882",
    "0x3eeCA62EC7E529E4fe079f563822289B6C0EEbA9",
    "0x1dd249B2B5fCdfFB9D7207bF2D70f94508Fdc874",
    "0x4c576B97376f55d189Cc71d8E8F61f0e6E080082",
    "0x13A6aA9914aFb1C528d32ACd273bAA623Af812b6",
    "0x9078716F1191b166dF47d35dE838d87c57f382fF",
]

data = [0 for _ in range(50)]
for l in range(1, 51):
    total = []
    for add in addresses:
        total.append(threading.Thread(target=f1, args=(add,)))
    tt = random.sample(total, k=l)
    assert len(tt) == l
    ss = time.time()
    for i in range(l):
        tt[i].start()
    for i in range(l):
        tt[i].join()
    data[l - 1] = time.time() - ss
    print(l, data[l - 1])
    requests.get("http://127.0.0.1:5000/cache")
    time.sleep(1)

import matplotlib.pyplot as plt

with open(f"result_{sys.argv[1]}.json", "w") as f:
    json.dump(data, f)
plotdata = data
plt.plot(plotdata)
plt.title("Number of Requests vs Time to Complete")
plt.ylabel("Time to Finish All Requests (s)")
plt.xlabel("Number of Requests")
plt.savefig(f"result_{sys.argv[1]}.jpg")
