import XCTest
@testable import HeliosKit

final class HeliosTests: XCTestCase {

    override func setUp() async throws {
        try await Helios.shared.start(rpcURL: Config.rpcUrl)
        try await Helios.shared.waitUntilSynced()
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
        XCTAssertEqual(gas, 21000)
    }

    func test_chainId() async throws {
        let chainId = try await Helios.shared.chainId()
        XCTAssertEqual(chainId, 0x01)
    }

    func test_getGasPrice() async throws {
        let gasPrice = try await Helios.shared.getGasPrice()
        XCTAssertEqual(gasPrice, "23000901906")
    }

    func test_getPriorityFee() async throws {
        let priorityFee = try await Helios.shared.getPriorityFee()
        XCTAssertEqual(priorityFee, "1000000000")
    }

    func test_getBlockNumber() async throws {
        let blockNumber = try await Helios.shared.getBlockNumber()
        XCTAssertEqual(blockNumber, "18444403")
    }

    func test_getCoinbase() async throws {
        let coinbase = try await Helios.shared.getCoinbase()
        XCTAssertEqual(coinbase, "0x690b9a9e9aa1c9db991c7721a92d351db4fac990")
    }

    func test_getBalance() async throws {
        let balance = try await Helios.shared.getBalance(
            of: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
            at: .latest
        )
        XCTAssertEqual(balance, "3123183824339947306")
    }

    func test_getNonce() async throws {
        let nonce = try await Helios.shared.getNonce(
            of: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
            at: .latest
        )
        XCTAssertEqual(nonce, 400183)
    }

    func test_getBlock() async throws {
        let block = try await Helios.shared.getBlock(.finalized, shouldIncludeTransactions: true)

        print(block)
        XCTAssertEqual(block.hash, "0xbde72d14278fead2a41eeefc01ccf14f07f0e4f8fa83a0ce452571d4f841c721")
    }

    func test_getBlockByHash() async throws {
        let block = try await Helios.shared.getBlock(byHash: "0x2f13cd7053db7bba8db48e4beb79ddbf7256c50ed9921cbb466f3aeddc067c45", shouldIncludeTransactions: true)

        print(block)
        XCTAssertEqual(block.hash, "0x2f13cd7053db7bba8db48e4beb79ddbf7256c50ed9921cbb466f3aeddc067c45")
    }

    func test_getBlockTransactionCountByHash() async throws {
        let count = try await Helios.shared.getBlockTransactionCount(byHash: "0x2f13cd7053db7bba8db48e4beb79ddbf7256c50ed9921cbb466f3aeddc067c45")
        XCTAssertEqual(count, 261)
    }

    func test_getBlockTransactionCount() async throws {
        let count = try await Helios.shared.getBlockTransactionCount(at: .latest)
        XCTAssertEqual(count, 135)
    }

    func test_getTransactionReceipt() async throws {
        let receipt = try await Helios.shared.getTransactionReceipt(transactionHash: "0x9f1b99098af50490a0257de83942b3a9ca10db0d20a7a4d7f75026bc1eb33154")

        print(receipt)
        XCTAssertEqual(receipt.transactionHash, "0x9f1b99098af50490a0257de83942b3a9ca10db0d20a7a4d7f75026bc1eb33154")
    }

    func test_getTransaction() async throws {
        let transaction = try await Helios.shared.getTransaction("0x9f1b99098af50490a0257de83942b3a9ca10db0d20a7a4d7f75026bc1eb33154")

        print(transaction)
        XCTAssertEqual(transaction.hash, "0x9f1b99098af50490a0257de83942b3a9ca10db0d20a7a4d7f75026bc1eb33154")
    }

    func test_getTransactionInBlock() async throws {
        let transaction = try await Helios.shared.getTransaction(
            inBlock: "0xbec92e0c2fdc027986467d083f2b35970453e30fff4be095cde988d76693eca9",
            atIndex: 0
        )

        print(transaction)
        XCTAssertEqual(transaction.hash, "0x9f1b99098af50490a0257de83942b3a9ca10db0d20a7a4d7f75026bc1eb33154")
    }

    func test_getLogs() async throws {
        let logs = try await Helios.shared.getLogs(
            from: .custom(18444394),
            to: .custom(18444394),
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            topics: [
                "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef", // keccak(Transfer(address,address,uint256))
                "0x000000000000000000000000aae2c17cd80b0c59a4c456c0e79607f6cb9fb6da", // from
                "0x000000000000000000000000ed42b9b88eed022ce284d4ee9814937aadead3ea"  // to

            ]
        )
        print(logs)
        XCTAssertEqual(logs.count, 1)
        XCTAssertEqual(logs.first?.data.hexEncodedString(), "0x000000000000000000000000000000000000000000000000000000003b9aca00")

        let logsByHash = try await Helios.shared.getLogs(
            at: "0x9847ed3635147133c1288677fb2abc75d4820d8377db6a7f7f9fa38865bfa8f1",
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            topics: [
                "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef", // keccak(Transfer(address,address,uint256))
                "0x000000000000000000000000aae2c17cd80b0c59a4c456c0e79607f6cb9fb6da", // from
                "0x000000000000000000000000ed42b9b88eed022ce284d4ee9814937aadead3ea"  // to
            ]
        )
        print(logsByHash)
        XCTAssertEqual(logsByHash.count, 1)
        XCTAssertEqual(logs.first?.data.hexEncodedString(), "0x000000000000000000000000000000000000000000000000000000003b9aca00")
    }

    func test_getCode() async throws {
        let code = try await Helios.shared.getCode(
            for: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            at: .latest
        )

        XCTAssertEqual(code.count, 11075)
    }

    func test_getCode_forEOA() async throws {
        let code = try await Helios.shared.getCode(
            for: "0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990",
            at: .latest
        )

        XCTAssertEqual(code.count, 0)
    }

    func test_getStorage() async throws {
        let storage = try await Helios.shared.getStorage(
            for: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            atSlot: "0x0000000000000000000000000000000000000000000000000000000000000000",
            block: .latest
        )

        XCTAssertEqual(storage, "0x000000000000000000000000c6cde7c39eb2f0f0095f41570af89efc2c1ea828")
    }

    func test_syncing() async throws {
        let status = try await Helios.shared.syncing()

        XCTAssertEqual(status, .synced)
    }
}

private extension Dictionary {
    func prettyPrint() throws {
        let data = try JSONSerialization.data(withJSONObject: self, options: [.sortedKeys, .prettyPrinted])
        guard let text = String(data: data, encoding: .utf8) else { return }
        print(text)
    }
}
