import XCTest
@testable import HeliosKit

final class HeliosTests: XCTestCase {

    override func setUp() async throws {
        try await Helios.shared.start(rpcURL: Config.rpcUrl, checkpoint: "0x793da86cdd7aac6f2fbe2dabb81c40ee8ea65752caec3530e13fce23d6ac2804", dataDirectory: nil)
    }

    override func tearDown() async throws {
        await Helios.shared.shutdown()
    }

    func test_rpcCall() async throws {
        let (data, _) = try await Helios.shared.call(method: "eth_getBalance", params: ["0x8C8D7C46219D9205f056f28fee5950aD564d7465", "latest"])
        let json = try JSONSerialization.jsonObject(with: data) as? [String: String]

        print("Response:")
        try json?.prettyPrint()
        
        XCTAssertNotNil(json?["result"])
        XCTAssert(json?["result"] != "0x")
        XCTAssert(json?["result"] != "")
    }

    func test_evmCall() async throws {
        let data = try await Helios.shared.call(
            callOptions: EVMCallOptions(
                to: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
                data: "0x06fdde03" // keccak(name())
            ),
            at: .finalized
        )

        let string = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertTrue(string.localizedStandardContains("Tether USD"))
    }

    func test_sendRawTransaction() async throws {
        let hash = try await Helios.shared.sendRawTransaction(Config.rawTransaction)
        print(hash)
        XCTAssertEqual(hash, "0x46cea5de834587c4b8bad396ae276de7a87c7c497d1079f0c3430481d83e50de")
    }

    func test_estimateGas() async throws {
        let gas = try await Helios.shared.estimateGas(
            for: EVMCallOptions(
                to: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
                value: "1000000000000000000"
            )
        )
        XCTAssertEqual(gas, 23100)
    }

    func test_chainId() async throws {
        let chainId = try await Helios.shared.chainId()
        XCTAssertEqual(chainId, 0x01)
    }

    func test_getGasPrice() async throws {
        let gasPrice = try await Helios.shared.getGasPrice()
        XCTAssertEqual(gasPrice, "32797664129")
    }

    func test_getPriorityFee() async throws {
        let priorityFee = try await Helios.shared.getPriorityFee()
        XCTAssertEqual(priorityFee, "1000000000")
    }

    func test_getBlockNumber() async throws {
        let blockNumber = try await Helios.shared.getBlockNumber()
        XCTAssertEqual(blockNumber, 16770609)
    }

    func test_getCoinbase() async throws {
        let coinbase = try await Helios.shared.getCoinbase()
        XCTAssertEqual(coinbase, "0xdafea492d9c6733ae3d56b7ed1adb60692c98bc5")
    }

    func test_getBalance() async throws {
        let balance = try await Helios.shared.getBalance(
            of: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
            at: .custom(16766328)
        )
        XCTAssertEqual(balance, "2677562242948815775")
    }

    func test_getNonce() async throws {
        let nonce = try await Helios.shared.getNonce(
            of: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
            at: .custom(16769077)
        )
        XCTAssertEqual(nonce, 212736)
    }

    func test_getBlock() async throws {
        let block = try await Helios.shared.getBlock(.custom(16801826), shouldIncludeTransactions: true)

        print(block)
        XCTAssertEqual(block.hash, "0xbde72d14278fead2a41eeefc01ccf14f07f0e4f8fa83a0ce452571d4f841c721")
    }

    func test_getBlockByHash() async throws {
        let block = try await Helios.shared.getBlock(byHash: "0xbde72d14278fead2a41eeefc01ccf14f07f0e4f8fa83a0ce452571d4f841c721", shouldIncludeTransactions: true)

        print(block)
        XCTAssertEqual(block.hash, "0xbde72d14278fead2a41eeefc01ccf14f07f0e4f8fa83a0ce452571d4f841c721")
    }

    func test_getBlockTransactionCountByHash() async throws {
        let count = try await Helios.shared.getBlockTransactionCount(byHash: "0xd3c86647db6164acc32e4784b2be98485a1b17384b36ecd4547781dd80ece802")
        XCTAssertEqual(count, 103)
    }

    func test_getBlockTransactionCount() async throws {
        let count = try await Helios.shared.getBlockTransactionCount(at: .custom(16769077))
        XCTAssertEqual(count, 159)
    }

    func test_getTransactionReceipt() async throws {
        let receipt = try await Helios.shared.getTransactionReceipt(transactionHash: "0xb925f78e4ee3d128418fa6f228de42e8f228290f05e2bb47528d3ffdaa5f1cdc")

        print(receipt)
        XCTAssertEqual(receipt.transactionHash, "0xb925f78e4ee3d128418fa6f228de42e8f228290f05e2bb47528d3ffdaa5f1cdc")
    }

    func test_getTransaction() async throws {
        let transaction = try await Helios.shared.getTransaction("0x46cea5de834587c4b8bad396ae276de7a87c7c497d1079f0c3430481d83e50de")

        print(transaction)
        XCTAssertEqual(transaction.hash, "0x46cea5de834587c4b8bad396ae276de7a87c7c497d1079f0c3430481d83e50de")
    }

    func test_getTransactionInBlock() async throws {
        let transaction = try await Helios.shared.getTransaction(
            inBlock: "0xbde72d14278fead2a41eeefc01ccf14f07f0e4f8fa83a0ce452571d4f841c721",
            atIndex: 86
        )

        print(transaction)
        XCTAssertEqual(transaction.hash, "0x13ae5e0cbaf39bd3978d54f3c47ba8706833fe8309b647c2bdfddfabeb0ddbda")
    }

    func test_getLogs() async throws {
        let logs = try await Helios.shared.getLogs(
            from: .custom(16799232),
            to: .custom(16799232),
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            topics: [
                "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef", // keccak(Transfer(address,address,uint256))
                "0x000000000000000000000000e29624a8ae6ff5033335e3a57b946a57f67968cf", // from
                "0x00000000000000000000000055799ce8e19e3e5d445a643bad1fbc1a5a86f16f"  // to

            ]
        )
        print(logs)
        XCTAssertEqual(logs.count, 1)

        let logsByHash = try await Helios.shared.getLogs(
            at: "0xe61200d1be1af3c94dcbc091f01c8e3216910a8818d77e95f03a07539f9e56ab",
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            topics: [
                "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef", // keccak(Transfer(address,address,uint256))
                "0x000000000000000000000000e29624a8ae6ff5033335e3a57b946a57f67968cf", // from
                "0x00000000000000000000000055799ce8e19e3e5d445a643bad1fbc1a5a86f16f"  // to
            ]
        )
        print(logsByHash)
        XCTAssertEqual(logsByHash.count, 1)
    }

    func test_getCode() async throws {
        let code = try await Helios.shared.getCode(
            for: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            at: .custom(16769077)
        )

        XCTAssertEqual(code.count, 11075)
    }

    func test_getCode_forEOA() async throws {
        let code = try await Helios.shared.getCode(
            for: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
            at: .custom(16769109)
        )

        XCTAssertEqual(code.count, 0)
    }

    func test_getStorage() async throws {
        let storage = try await Helios.shared.getStorage(
            for: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            atSlot: "0x0000000000000000000000000000000000000000000000000000000000000000",
            block: .custom(16770471)
        )

        XCTAssertEqual(storage, "0x000000000000000000000000c6cde7c39eb2f0f0095f41570af89efc2c1ea828")
    }

    func test_getHeader() async throws {
        let header = try await Helios.shared.getHeader()

        print(header)
        XCTAssertEqual(header.bodyRoot, "0x030f9e8e4792b24d3d169776a3c0d288e9644262fd8b1fa9ba178abcbc9c438c")
    }
}

private extension Dictionary {
    func prettyPrint() throws {
        let data = try JSONSerialization.data(withJSONObject: self, options: [.sortedKeys, .prettyPrinted])
        guard let text = String(data: data, encoding: .utf8) else { return }
        print(text)
    }
}
