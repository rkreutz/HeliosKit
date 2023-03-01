#! /bin/sh -e

set -e

HELIOS_VERSION=0.1.0
ROOT_DIRECTORY=`pwd`
BUILD_DIRECTORY="$ROOT_DIRECTORY/.build/helios-rs"
HELIOS_DIRECTORY="$BUILD_DIRECTORY/helios"
OPENSSL_DIRECTORY="$BUILD_DIRECTORY/openssl"

if [ -z $1 ]; then
    BUILD_MODE="release"
    echo "\033[0;36m▸ Building for release\033[0m"
elif [ $1 = "debug" ]; then
    BUILD_MODE="debug"
    echo "\033[0;36m▸ Building for debug\033[0m"
else
    BUILD_MODE="release"
    echo "\033[0;36m▸ Building for release\033[0m"
fi

if [ ! -d "$BUILD_DIRECTORY" ]; then
    echo "\033[0;36m▸ Create build directory\033[0m"
    mkdir -p $BUILD_DIRECTORY
fi

echo "\033[0;36m▸ Checkout rust-openssl\033[0m"
if [ ! -d $OPENSSL_DIRECTORY ]; then
    git clone https://github.com/sfackler/rust-openssl $OPENSSL_DIRECTORY
fi
cd $OPENSSL_DIRECTORY
git checkout -f b30313a9775ed861ce9456745952e3012e5602ea
# For compatibility issues with iOS simulator
sed -i '' 's/openssl-src = { version = "111", optional = true }/openssl-src = { version = "300", optional = true }/' "$OPENSSL_DIRECTORY/openssl-sys/Cargo.toml"

echo "\033[0;36m▸ Checkout helios version $HELIOS_VERSION\033[0m"
if [ ! -d $HELIOS_DIRECTORY ]; then
    git clone https://github.com/a16z/helios $HELIOS_DIRECTORY
fi
cd $HELIOS_DIRECTORY
git checkout -f tags/$HELIOS_VERSION 

echo "\033[0;36m▸ Modify helios crate\033[0m"
sed -i '' "s/^version = .*$/version = \"$HELIOS_VERSION\"/" "$HELIOS_DIRECTORY/Cargo.toml"
sed -i '' '/^[[]patch.crates-io[]]/a\'$'\n'"openssl-sys = { path = \"$OPENSSL_DIRECTORY/openssl-sys\" }"$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
sed -i '' '/^[[]package[]]/a\'$'\n''build = "build.rs"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
sed -i '' 's/^[[]dependencies[]]/[build-dependencies]\nswift-bridge-build = "0.1"\n\n[dependencies]/' "$HELIOS_DIRECTORY/Cargo.toml"
sed -i '' '/^[[]dependencies[]]/a\'$'\n''swift-bridge = { version = "0.1", features = ["async"] }'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
sed -i '' '/^[[]dependencies[]]/a\'$'\n''env_logger = "0.9.0"'$'\n' "$HELIOS_DIRECTORY/Cargo.toml"
echo "[lib]" >> "$HELIOS_DIRECTORY/Cargo.toml"
echo "name = \"helios\"" >> "$HELIOS_DIRECTORY/Cargo.toml"
echo "crate-type = [\"staticlib\"]" >> "$HELIOS_DIRECTORY/Cargo.toml"
# Create build.rs
echo 'dXNlIHN0ZDo6cGF0aDo6UGF0aEJ1ZjsKCmZuIG1haW4oKSB7CiAgbGV0IG91dF9kaXIgPSBQYXRoQnVmOjpmcm9tKCIuL2dlbmVyYXRlZCIpOwogIGxldCBicmlkZ2VzID0gdmVjIVsic3JjL2xpYi5ycyJdOwogIGZvciBwYXRoIGluICZicmlkZ2VzIHsKICAgIHByaW50bG4hKCJjYXJnbzpyZXJ1bi1pZi1jaGFuZ2VkPXt9IiwgcGF0aCk7CiAgfQogIHN3aWZ0X2JyaWRnZV9idWlsZDo6cGFyc2VfYnJpZGdlcyhicmlkZ2VzKQogICAgLndyaXRlX2FsbF9jb25jYXRlbmF0ZWQob3V0X2RpciwgZW52ISgiQ0FSR09fUEtHX05BTUUiKSk7Cn0K' | base64 --decode -o $HELIOS_DIRECTORY/build.rs
# Create src/lib.rs
echo 'dXNlIDo6Y2xpZW50Ojp7ZGF0YWJhc2U6OkZpbGVEQiwgQ2xpZW50LCBDbGllbnRCdWlsZGVyfTsKdXNlIDo6Y29uZmlnOjp7bmV0d29ya3N9OwoKI1tzd2lmdF9icmlkZ2U6OmJyaWRnZV0KbW9kIGZmaSB7CgogIGVudW0gSGVsaW9zTmV0d29yayB7CiAgICBNQUlOTkVULAogICAgR09FUkxJLAogIH0KCiAgI1tzd2lmdF9icmlkZ2Uoc3dpZnRfcmVwciA9ICJzdHJ1Y3QiKV0KICBzdHJ1Y3QgU3RhcnRVcFN0YXRlIHsKICAgIHN0YXJ0ZWQ6IGJvb2wsCiAgICBlcnJvcjogU3RyaW5nLAogIH0KCiAgZXh0ZXJuICJSdXN0IiB7CiAgICB0eXBlIEhlbGlvc0NsaWVudDsKCiAgICAjW3N3aWZ0X2JyaWRnZShpbml0KV0KICAgIGZuIG5ldygpIC0+IEhlbGlvc0NsaWVudDsKCiAgICBhc3luYyBmbiBzdGFydCgKICAgICAgJm11dCBzZWxmLCAKICAgICAgdW50cnVzdGVkX3JwY191cmw6IFN0cmluZywgCiAgICAgIGNvbnNlbnN1c19ycGNfdXJsOiBTdHJpbmcsCiAgICAgIGNoZWNrcG9pbnQ6IE9wdGlvbjxTdHJpbmc+LAogICAgICBycGNfcG9ydDogdTE2LAogICAgICBuZXR3b3JrOiBIZWxpb3NOZXR3b3JrCiAgICApIC0+IFN0YXJ0VXBTdGF0ZTsKCiAgICBhc3luYyBmbiBzaHV0ZG93bigmbXV0IHNlbGYpOwogIH0KfQoKaW1wbCBIZWxpb3NDbGllbnQgewoKICBwdWIgZm4gbmV3KCkgLT4gSGVsaW9zQ2xpZW50IHsKICAgIEhlbGlvc0NsaWVudCB7CiAgICAgIGNsaWVudDogTm9uZSwKICAgICAgaXNfbG9nZ2luZzogZmFsc2UsCiAgICB9CiAgfQoKICBhc3luYyBmbiBzdGFydCgKICAgICZtdXQgc2VsZiwKICAgIHVudHJ1c3RlZF9ycGNfdXJsOiBTdHJpbmcsCiAgICBjb25zZW5zdXNfcnBjX3VybDogU3RyaW5nLAogICAgY2hlY2twb2ludDogT3B0aW9uPFN0cmluZz4sCiAgICBycGNfcG9ydDogdTE2LAogICAgbmV0d29yazogZmZpOjpIZWxpb3NOZXR3b3JrLAogICkgLT4gZmZpOjpTdGFydFVwU3RhdGUgewogICAgaWYgbGV0IFNvbWUoX2NsaWVudCkgPSAmc2VsZi5jbGllbnQgewogICAgICByZXR1cm4gZmZpOjpTdGFydFVwU3RhdGUgewogICAgICAgIHN0YXJ0ZWQ6IGZhbHNlLAogICAgICAgIGVycm9yOiAiQ2xpZW50IGhhcyBhbHJlYWR5IHN0YXJ0ZWQuIi50b19zdHJpbmcoKSwKICAgICAgfTsKICAgIH0KCiAgICBpZiAhc2VsZi5pc19sb2dnaW5nIHsKICAgICAgc2VsZi5pc19sb2dnaW5nID0gdHJ1ZTsKICAgICAgZW52X2xvZ2dlcjo6aW5pdCgpOwogICAgfQoKICAgIGxldCBtdXQgY2xpZW50X2J1aWxkZXIgPSBDbGllbnRCdWlsZGVyOjpuZXcoKQogICAgICAubmV0d29yayhuZXR3b3JrLnRvX2Jhc2VfbmV0d29yaygpKQogICAgICAuZXhlY3V0aW9uX3JwYygmdW50cnVzdGVkX3JwY191cmwpCiAgICAgIC5jb25zZW5zdXNfcnBjKCZjb25zZW5zdXNfcnBjX3VybCkKICAgICAgLnJwY19wb3J0KHJwY19wb3J0KTsKICAgIAogICAgaWYgbGV0IFNvbWUoY2hlY2twb2ludCkgPSAmY2hlY2twb2ludCB7CiAgICAgIGNsaWVudF9idWlsZGVyID0gY2xpZW50X2J1aWxkZXIuY2hlY2twb2ludCgmY2hlY2twb2ludCk7CiAgICB9CgogICAgbWF0Y2ggY2xpZW50X2J1aWxkZXIuYnVpbGQoKSB7CiAgICAgIEVycihlcnJvcikgPT4gcmV0dXJuIGZmaTo6U3RhcnRVcFN0YXRlIHsKICAgICAgICBzdGFydGVkOiBmYWxzZSwKICAgICAgICBlcnJvcjogZXJyb3IudG9fc3RyaW5nKCksCiAgICAgIH0sCiAgICAgIE9rKG11dCBjbGllbnQpID0+IHsKICAgICAgICBtYXRjaCBjbGllbnQuc3RhcnQoKS5hd2FpdCB7CiAgICAgICAgICBFcnIoZXJyb3IpID0+IHJldHVybiBmZmk6OlN0YXJ0VXBTdGF0ZSB7CiAgICAgICAgICAgIHN0YXJ0ZWQ6IGZhbHNlLAogICAgICAgICAgICBlcnJvcjogZXJyb3IudG9fc3RyaW5nKCksCiAgICAgICAgICB9LAogICAgICAgICAgT2soKCkpID0+IHsKICAgICAgICAgICAgc2VsZi5jbGllbnQgPSBTb21lKGNsaWVudCk7CiAgICAgICAgICAgIHJldHVybiBmZmk6OlN0YXJ0VXBTdGF0ZSB7CiAgICAgICAgICAgICAgc3RhcnRlZDogdHJ1ZSwKICAgICAgICAgICAgICBlcnJvcjogIiIudG9fc3RyaW5nKCksCiAgICAgICAgICAgIH07CiAgICAgICAgICB9LAogICAgICAgIH0KICAgICAgfSwKICAgIH0KICB9CgogIGFzeW5jIGZuIHNodXRkb3duKCZtdXQgc2VsZikgewogICAgaWYgbGV0IFNvbWUoY2xpZW50KSA9ICZzZWxmLmNsaWVudCB7CiAgICAgIGNsaWVudC5zaHV0ZG93bigpLmF3YWl0OwogICAgICBzZWxmLmNsaWVudCA9IE5vbmU7CiAgICB9CiAgfQp9CgppbXBsIGZmaTo6SGVsaW9zTmV0d29yayB7CgogIGZuIHRvX2Jhc2VfbmV0d29yaygmc2VsZikgLT4gbmV0d29ya3M6Ok5ldHdvcmsgewogICAgICBtYXRjaCBzZWxmIHsKICAgICAgICAgIFNlbGY6Ok1BSU5ORVQgPT4gbmV0d29ya3M6Ok5ldHdvcms6Ok1BSU5ORVQsCiAgICAgICAgICBTZWxmOjpHT0VSTEkgPT4gbmV0d29ya3M6Ok5ldHdvcms6OkdPRVJMSSwKICAgICAgfQogIH0KfQoKcHViIHN0cnVjdCBIZWxpb3NDbGllbnQgewogIGNsaWVudDogT3B0aW9uPENsaWVudDxGaWxlREI+PiwKICBpc19sb2dnaW5nOiBib29sLAp9Cg==' | base64 --decode -o $HELIOS_DIRECTORY/src/lib.rs

export SWIFT_BRIDGE_OUT_DIR="$HELIOS_DIRECTORY/generated"

echo "\033[0;36m▸ Update toolchain\033[0m"
rustup update

echo "\033[0;36m▸ Install nightly toolchain\033[0m"
rustup toolchain install nightly

echo "\033[0;36m▸ Install targets\033[0m"
rustup target add --toolchain nightly aarch64-apple-ios
rustup target add --toolchain nightly aarch64-apple-ios-sim
rustup target add --toolchain nightly x86_64-apple-ios
rustup target add --toolchain nightly aarch64-apple-darwin
rustup target add --toolchain nightly x86_64-apple-darwin

echo "\033[0;36m▸ Install rustup components\033[0m"
rustup component add rust-src --toolchain nightly-x86_64-apple-darwin

echo "\033[0;36m▸ Build aarch64-apple-ios\033[0m"
cargo +nightly build --target aarch64-apple-ios $([[ $BUILD_MODE = "release" ]] && echo --release)

echo "\033[0;36m▸ Build aarch64-apple-ios-sim\033[0m"
cargo +nightly build -Z build-std --target aarch64-apple-ios-sim $([[ $BUILD_MODE = "release" ]] && echo --release)

echo "\033[0;36m▸ Build x86_64-apple-ios\033[0m"
cargo +nightly build --target x86_64-apple-ios $([[ $BUILD_MODE = "release" ]] && echo --release)

echo "\033[0;36m▸ Build aarch64-apple-darwin\033[0m"
cargo +nightly build --target aarch64-apple-darwin $([[ $BUILD_MODE = "release" ]] && echo --release)

echo "\033[0;36m▸ Build x86_64-apple-darwin\033[0m"
cargo +nightly build --target x86_64-apple-darwin $([[ $BUILD_MODE = "release" ]] && echo --release)

echo "\033[0;36m▸ Lipo simulator\033[0m"
mkdir -p ./target/apple-ios-simulator/$BUILD_MODE
lipo -create  \
    ./target/x86_64-apple-ios/$BUILD_MODE/libhelios.a \
    ./target/aarch64-apple-ios-sim/$BUILD_MODE/libhelios.a \
    -output ./target/apple-ios-simulator/$BUILD_MODE/libhelios.a

echo "\033[0;36m▸ Lipo macOS\033[0m"
mkdir -p ./target/apple-darwin/$BUILD_MODE
lipo -create  \
   ./target/x86_64-apple-darwin/$BUILD_MODE/libhelios.a \
   ./target/aarch64-apple-darwin/$BUILD_MODE/libhelios.a \
   -output ./target/apple-darwin/$BUILD_MODE/libhelios.a

echo "\033[0;36m▸ Generate C headers\033[0m"
if [ -d $HELIOS_DIRECTORY/headers ]; then
    rm -rf $HELIOS_DIRECTORY/headers
fi
mkdir $HELIOS_DIRECTORY/headers
cp $HELIOS_DIRECTORY/generated/SwiftBridgeCore.h $HELIOS_DIRECTORY/headers/SwiftBridgeCore.h
cp $HELIOS_DIRECTORY/generated/helios/helios.h $HELIOS_DIRECTORY/headers/helios.h
echo "bW9kdWxlIGhlbGlvcyB7CiAgICBoZWFkZXIgIlN3aWZ0QnJpZGdlQ29yZS5oIgogICAgaGVhZGVyICJoZWxpb3MuaCIKICAgIGV4cG9ydCAqCn0K" | base64 --decode -o $HELIOS_DIRECTORY/headers/module.modulemap

if [ -d "$BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE" ]; then
    echo "\033[0;36m▸ Delete old build artefacts\033[0m"
    rm -rf $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE
fi

echo "\033[0;36m▸ Create helios.xcframework\033[0m"
xcodebuild -create-xcframework \
        -library $HELIOS_DIRECTORY/target/apple-ios-simulator/$BUILD_MODE/libhelios.a \
        -headers $HELIOS_DIRECTORY/headers \
        -library $HELIOS_DIRECTORY/target/aarch64-apple-ios/$BUILD_MODE/libhelios.a \
        -headers $HELIOS_DIRECTORY/headers \
        -library $HELIOS_DIRECTORY/target/apple-darwin/$BUILD_MODE/libhelios.a \
        -headers $HELIOS_DIRECTORY/headers \
        -output $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.xcframework

if [ $BUILD_MODE = "release" ]; then
    echo "\033[0;36m▸ Compress helios.xcframework\033[0m"
    ditto -c -k --sequesterRsrc --keepParent $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.xcframework $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.xcframework.zip

    echo "\033[0;36m▸ Compute helios.xcframework checksum\033[0m"
    swift package compute-checksum $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.xcframework.zip > $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.xcframework.zip.checksum
fi

echo "\033[0;36m▸ Copy Swift bridging files\033[0m"
cp $HELIOS_DIRECTORY/generated/SwiftBridgeCore.swift $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/SwiftBridgeCore.swift
sed -i '' '1i\'$'\n''import helios'$'\n' $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/SwiftBridgeCore.swift
sed -i '' 's/public //' $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/SwiftBridgeCore.swift
cp $HELIOS_DIRECTORY/generated/helios/helios.swift $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.swift
sed -i '' '1i\'$'\n''import helios'$'\n' $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.swift
sed -i '' 's/public //' $BUILD_DIRECTORY/build/$HELIOS_VERSION/$BUILD_MODE/helios.swift

echo "\033[0;32m▸ BUILD SUCCESSFUL!"
echo ''
echo "Built artefacts can be found at $BUILD_DIRECTORY/build/$HELIOS_VERSION\033[0m"
