#! /bin/zsh

log::error() {
    echo "\033[0;31m$@\033[0m" 1>&2
}

log::success() {
    echo "\033[0;32m$@\033[0m"
}

log::message() {
    echo "\033[0;36m▸ $@\033[0m"
}

log::info() {
    echo "\033[1;37m$@\033[0m"
}

env::setup() {
    log::message "Settig up env"
    if [ -z $PACKAGE_VERSION ]; then
        log::error 'Must specify $PACKAGE_VERSION'
        exit -1
    fi
    log::info "PACKAGE_VERSION=$PACKAGE_VERSION"
    export HELIOS_VERSION=${HELIOS_VERSION:-$PACKAGE_VERSION}
    log::info "HELIOS_VERSION=$HELIOS_VERSION"
    export ROOT_DIRECTORY=${ROOT_DIRECTORY:-`pwd`}
    log::info "ROOT_DIRECTORY=$ROOT_DIRECTORY"
    export BUILD_DIRECTORY=${BUILD_DIRECTORY:-"$ROOT_DIRECTORY/.build/helios-rs"}
    log::info "BUILD_DIRECTORY=$BUILD_DIRECTORY"
    export HELIOS_DIRECTORY=${HELIOS_DIRECTORY:-"$BUILD_DIRECTORY/helios"}
    log::info "HELIOS_DIRECTORY=$HELIOS_DIRECTORY"
    export OPENSSL_DIRECTORY=${OPENSSL_DIRECTORY:-"$BUILD_DIRECTORY/openssl"}
    log::info "OPENSSL_DIRECTORY=$OPENSSL_DIRECTORY"
    export RUST_TOOLCHAIN=${RUST_TOOLCHAIN:-'nightly-2023-01-23'}
    log::info "RUST_TOOLCHAIN=$RUST_TOOLCHAIN"
    export ETHERS_VERSION=${ETHERS_VERSION:-'1.0'}
    log::info "ETHERS_VERSION=$ETHERS_VERSION"
    export SWIFT_BRIDGE_VERSION=${SWIFT_BRIDGE_VERSION:-'0.1'}
    log::info "SWIFT_BRIDGE_VERSION=$SWIFT_BRIDGE_VERSION"
    export SWIFT_BRIDGE_OUT_DIR="$HELIOS_DIRECTORY/generated"
}

env::build_configuration() {
    if [ -z $1 ]; then
        BUILD_CONFIG="release"
    elif [ $1 = "debug" ]; then
        BUILD_CONFIG="debug"
    else
        BUILD_CONFIG="release"
    fi

    log::message "Building for $BUILD_CONFIG"
    export BUILD_CONFIG
}

pre_build::create_build_directory() {
    if [ ! -d "$BUILD_DIRECTORY" ]; then
        log::message "Creating build directory"
        mkdir -p $BUILD_DIRECTORY
    fi
}

pre_build::setup_openssl() {
    log::message "Checkout rust-openssl"
    if [ -z $1 ]; then
        log::error 'Must specify commit hash as input to pre_build::setup_openssl'
        exit -1
    fi
    if [ ! -d $OPENSSL_DIRECTORY ]; then
        git clone https://github.com/sfackler/rust-openssl $OPENSSL_DIRECTORY
    fi
    cd $OPENSSL_DIRECTORY
    git checkout -f $1
    # For compatibility issues with iOS simulator
    sed -i '' 's/openssl-src = { version = "111", optional = true }/openssl-src = { version = "300", optional = true }/' "$OPENSSL_DIRECTORY/openssl-sys/Cargo.toml"
}

pre_build::setup_helios() {
    log::message "Checkout helios version $HELIOS_VERSION"
    if [ ! -d $HELIOS_DIRECTORY ]; then
        git clone https://github.com/a16z/helios $HELIOS_DIRECTORY
    fi
    cd $HELIOS_DIRECTORY
    git checkout -f tags/$HELIOS_VERSION
}

pre_build::modify_helios() {
    log::message "Modify helios crate"
    if [ -z $1 ]; then
        log::error 'Must specify base64 encoded src/lib.rs as input to pre_build::modify_helios'
        exit -1
    fi

    # Create src/lib.rs from input
    echo $1 | base64 --decode -o $HELIOS_DIRECTORY/src/lib.rs

    # Set helios crate version
    sed -i '' "s/^version = .*$/version = \"$HELIOS_VERSION\"/" "$HELIOS_DIRECTORY/Cargo.toml"

    # Set crate build.rs and create build.rs file
    sed -i '' '/^[[]package[]]/a\'$'\n''build = "build.rs"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
    echo 'dXNlIHN0ZDo6cGF0aDo6UGF0aEJ1ZjsKCmZuIG1haW4oKSB7CiAgbGV0IG91dF9kaXIgPSBQYXRoQnVmOjpmcm9tKCIuL2dlbmVyYXRlZCIpOwogIGxldCBicmlkZ2VzID0gdmVjIVsic3JjL2xpYi5ycyJdOwogIGZvciBwYXRoIGluICZicmlkZ2VzIHsKICAgIHByaW50bG4hKCJjYXJnbzpyZXJ1bi1pZi1jaGFuZ2VkPXt9IiwgcGF0aCk7CiAgfQogIHN3aWZ0X2JyaWRnZV9idWlsZDo6cGFyc2VfYnJpZGdlcyhicmlkZ2VzKQogICAgLndyaXRlX2FsbF9jb25jYXRlbmF0ZWQob3V0X2RpciwgZW52ISgiQ0FSR09fUEtHX05BTUUiKSk7Cn0K' | base64 --decode -o $HELIOS_DIRECTORY/build.rs

    # Add swift-bridge
    if grep -q "[[]build-dependencies[]]" "$HELIOS_DIRECTORY/Cargo.toml"; then
        sed -i '' '/^[[]build-dependencies[]]/a\'$'\n''swift-bridge-build = "'$SWIFT_BRIDGE_VERSION'"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
    else
        sed -i '' 's/^[[]dependencies[]]/[build-dependencies]\nswift-bridge-build = "'$SWIFT_BRIDGE_VERSION'"\n\n[dependencies]/' "$HELIOS_DIRECTORY/Cargo.toml"
    fi
    sed -i '' '/^[[]dependencies[]]/a\'$'\n''swift-bridge = { version = "'$SWIFT_BRIDGE_VERSION'", features = ["async"] }'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"

    # Add other dependencies
    sed -i '' '/^[[]dependencies[]]/a\'$'\n''hex = "0.4.3"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
    sed -i '' '/^[[]dependencies[]]/a\'$'\n''ethers = "'$ETHERS_VERSION'"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
    sed -i '' '/^[[]dependencies[]]/a\'$'\n''env_logger = "0.9.0"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"

    # This PR regressed builds on iOS: https://github.com/a16z/helios/pull/160
    # It would cause an error, "duplicate lang item in crate `core`: `sized`".
    sed -i '' "s/^panic = \"abort\"$//" "$HELIOS_DIRECTORY/Cargo.toml"

    # Modify/Add OpenSSL patch
    if grep -q "[[]patch[.]crates-io[]]" "$HELIOS_DIRECTORY/Cargo.toml"; then
        sed -i '' '/^[[]patch.crates-io[]]/a\'$'\n'"openssl-sys = { path = \"$OPENSSL_DIRECTORY/openssl-sys\" }"$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
    else
        echo "\n[patch.crates-io]" >> "$HELIOS_DIRECTORY/Cargo.toml"
        echo "openssl-sys = { path = \"$OPENSSL_DIRECTORY/openssl-sys\" }" >> "$HELIOS_DIRECTORY/Cargo.toml"
    fi

    # Change crate to lib
    echo "\n[lib]" >> "$HELIOS_DIRECTORY/Cargo.toml"
    echo "name = \"helios\"" >> "$HELIOS_DIRECTORY/Cargo.toml"
    echo "crate-type = [\"staticlib\"]" >> "$HELIOS_DIRECTORY/Cargo.toml"
}

rust::toolchain() {
    log::message "Install $RUST_TOOLCHAIN toolchain"
    rustup toolchain install $RUST_TOOLCHAIN
}

rust::targets() {
    log::message "Install targets"
    rustup target add --toolchain $RUST_TOOLCHAIN aarch64-apple-ios
    rustup target add --toolchain $RUST_TOOLCHAIN aarch64-apple-ios-sim
    rustup target add --toolchain $RUST_TOOLCHAIN x86_64-apple-ios
    rustup target add --toolchain $RUST_TOOLCHAIN aarch64-apple-darwin
    rustup target add --toolchain $RUST_TOOLCHAIN x86_64-apple-darwin
}

rust::components() {
    log::message "Install rustup components"
    rustup component add rust-src --toolchain $RUST_TOOLCHAIN-x86_64-apple-darwin
}

rust::setup() {
    rust::toolchain
    rust::targets
    rust::components
}

rust::build_target() {
    log::message "Build $1"
    if [ -z $1 ]; then
        log::error 'Must specify target as input to rust::build_target'
        exit -1
    fi
    cargo +$RUST_TOOLCHAIN build $([[ $1 = "aarch64-apple-ios-sim" ]] && echo "-Z build-std") --target $1 $([[ $BUILD_CONFIG = "release" ]] && echo --release)
}

rust::build_ios() {
    rust::build_target aarch64-apple-ios
}

rust::build_ios_sim() {
    rust::build_target aarch64-apple-ios-sim
    rust::build_target x86_64-apple-ios
}

rust::build_macos() {
    rust::build_target aarch64-apple-darwin
    rust::build_target x86_64-apple-darwin
}

rust::build() {
    rust::build_ios
    rust::build_ios_sim
    rust::build_macos
}

build::lipo_ios_sim() {
    log::message "Lipo iOS Simulator"
    mkdir -p $HELIOS_DIRECTORY/target/apple-ios-simulator/$BUILD_CONFIG
    lipo -create  \
        $HELIOS_DIRECTORY/target/x86_64-apple-ios/$BUILD_CONFIG/libhelios.a \
        $HELIOS_DIRECTORY/target/aarch64-apple-ios-sim/$BUILD_CONFIG/libhelios.a \
        -output $HELIOS_DIRECTORY/target/apple-ios-simulator/$BUILD_CONFIG/libhelios.a
}

build::lipo_macos() {
    log::message "Lipo macOS"
    mkdir -p $HELIOS_DIRECTORY/target/apple-darwin/$BUILD_CONFIG
    lipo -create  \
        $HELIOS_DIRECTORY/target/x86_64-apple-darwin/$BUILD_CONFIG/libhelios.a \
        $HELIOS_DIRECTORY/target/aarch64-apple-darwin/$BUILD_CONFIG/libhelios.a \
        -output $HELIOS_DIRECTORY/target/apple-darwin/$BUILD_CONFIG/libhelios.a
}

build::lipo() {
    build::lipo_ios_sim
    build::lipo_macos
}

build::generate_c_headers() {
    log::message "Generate C headers"
    if [ -d $HELIOS_DIRECTORY/headers ]; then
        rm -rf $HELIOS_DIRECTORY/headers
    fi
    mkdir $HELIOS_DIRECTORY/headers
    cp $HELIOS_DIRECTORY/generated/SwiftBridgeCore.h $HELIOS_DIRECTORY/headers/SwiftBridgeCore.h
    cp $HELIOS_DIRECTORY/generated/helios/helios.h $HELIOS_DIRECTORY/headers/helios.h
    echo "bW9kdWxlIGhlbGlvcyB7CiAgICBoZWFkZXIgIlN3aWZ0QnJpZGdlQ29yZS5oIgogICAgaGVhZGVyICJoZWxpb3MuaCIKICAgIGV4cG9ydCAqCn0K" | base64 --decode -o $HELIOS_DIRECTORY/headers/module.modulemap
}

build::xcframework() {
    if [ -d "$BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG" ]; then
        log::message "Delete old build artefacts"
        rm -rf $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG
    fi

    log::message "Create helios.xcframework"
    xcodebuild -create-xcframework \
        -library $HELIOS_DIRECTORY/target/apple-ios-simulator/$BUILD_CONFIG/libhelios.a \
        -headers $HELIOS_DIRECTORY/headers \
        -library $HELIOS_DIRECTORY/target/aarch64-apple-ios/$BUILD_CONFIG/libhelios.a \
        -headers $HELIOS_DIRECTORY/headers \
        -library $HELIOS_DIRECTORY/target/apple-darwin/$BUILD_CONFIG/libhelios.a \
        -headers $HELIOS_DIRECTORY/headers \
        -output $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.xcframework
}

post_build::compress() {
    if [ $BUILD_CONFIG = "release" ]; then
        log::message "Compress helios.xcframework"
        ditto -c -k --sequesterRsrc --keepParent $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.xcframework $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.xcframework.zip

        log::message "Compute helios.xcframework checksum"
        swift package compute-checksum $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.xcframework.zip > $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.xcframework.zip.checksum
    fi
}

post_build::copy_bridge_files() {
    log::message "Copy Swift bridging files"
    cp $HELIOS_DIRECTORY/generated/SwiftBridgeCore.swift $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/SwiftBridgeCore.swift
    sed -i '' '1i\'$'\n''import helios'$'\n' $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/SwiftBridgeCore.swift
    sed -i '' 's/public //' $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/SwiftBridgeCore.swift
    cp $HELIOS_DIRECTORY/generated/helios/helios.swift $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.swift
    sed -i '' '1i\'$'\n''import helios'$'\n' $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.swift
    sed -i '' 's/public //' $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG/helios.swift
}

post_build::success() {
    log::success "▸ BUILD SUCCESSFUL!"
    log::success ''
    log::success "Built artefacts can be found at $BUILD_DIRECTORY/build/$PACKAGE_VERSION/$BUILD_CONFIG"
}
