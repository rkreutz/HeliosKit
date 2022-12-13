## HeliosKit

![Swift 5.2](https://img.shields.io/badge/Swift-5.5-orange.svg)
[![Platforms](https://img.shields.io/badge/platforms-macOS%2010.15%20|%20iOS%2013-ff0000.svg?style=flat)](https://github.com/rkreutz/HeliosKit)
[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub tag](https://img.shields.io/github/tag/rkreutz/HeliosKit.svg)](https://GitHub.com/rkreutz/HeliosKit/tags/)

[Helios](https://github.com/a16z/helios) is a fully trustless, efficient, and portable Ethereum light client written in Rust.

Helios converts an untrusted centralized RPC endpoint into a safe unmanipulable local RPC for its users. It syncs in seconds, requires no storage, and is lightweight enough to run on mobile devices.

This Swift Package is a wrapper around Helios' Rust library.

## Installation

Add the package declaration to your project's manifest dependencies array:

```swift
.package(url: "https://github.com/rkreutz/HeliosKit.git", from: "0.1.0")
```

## Usage

You can start a client with:

```swift
let rpcURL = // URL to the unsafe RPC
try await Helios.shared.start(rpcURL: rpcURL)
```

**Have in mind that only one client can be running at all times.**

Once the client is up and running you can start doing RPC calls to it, it will be listening to `127.0.0.1:8545`.

You may also use the library to call methods from the RPC with:

```swift
let (data, _) = try await Helios.shared.call(method: "eth_getBalance", params: ["0x407d73d8a49eeb85d32cf465507dd71d507100c1", "latest"])
let response = String(data: data, encoding: .utf8)!
print(response) // {"jsonrpc":"2.0","result":"0x0000000000000000000000000000000000000000000000000000000000000000","id":...}
```

To shutdown your client gracefully, use the `shutdown()` method:

```swift
await Helios.shared.shutdown()
```

## Logging

You may enable logging of the Rust lib with an environment var at runtime (`RUST_LOG`). The library uses Rust's `env_logger` framework, so you may set the desired levels accordingly.

<img width="424" alt="Screen Shot 2022-12-13 at 18 31 46" src="https://user-images.githubusercontent.com/8869678/207416542-1851b65e-0dc8-4a1a-9281-c24519240452.png">

## Building locally

There is a `build.sh` script in the repo which can be used to build the `xcframework` for the [helios rust library](https://github.com/a16z/helios), this will create the XCFramework and place it (along with the Swift bridging files and checksum) in the `.build/helios-rs/build` directory. You may provide an additional parameter to the script to build a `debug` or `release` framework.

```bash
> sh build.sh debug # .build/helios-rs/build/debug/helios.xcframework

> sh build.sh # .build/helios-rs/build/release/helios.xcframework
```
