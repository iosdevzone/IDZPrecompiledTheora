DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $IDZ_BUILD_ROOT

IDZ_FW_NAME=Theora
IDZ_NAME=theora
IDZ_LIB_VERSION=1.1.1
IDZ_IOS_SDK_VERSION=8.0

IDZ_LIB=lib$IDZ_NAME
IDZ_LIB_ALL=$IDZ_LIBall.a
IDZ_LIB_VERSION=1.1.1
IDZ_LIB_DIR=$IDZ_LIB-$IDZ_LIB_VERSION
IDZ_ARCHIVE_SUFFIX=zip
IDZ_URL_DIR=http://downloads.xiph.org/releases/$IDZ_NAME

echo IDZ_LIB_DIR=$IDZ_LIB_DIR

mkdir -p $IDZ_LIB/$IDZ_LIB_VERSION
pushd $IDZ_LIB/$IDZ_LIB_VERSION

curl -L -O $IDZ_URL_DIR/$IDZ_LIB_DIR.$IDZ_ARCHIVE_SUFFIX
unzip $IDZ_LIB_DIR.$IDZ_ARCHIVE_SUFFIX

# Phone builds
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneOS-armv7
idz_configure armv7 ${IDZ_IOS_SDK_VERSION} $IDZ_LIB_DIR/configure
export IDZ_EXTRA_CONFIGURE_FLAGS=-with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneOS-armv7s
idz_configure armv7s ${IDZ_IOS_SDK_VERSION} $IDZ_LIB_DIR/configure
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneOS-arm64
idz_configure arm64 ${IDZ_IOS_SDK_VERSION} $IDZ_LIB_DIR/configure

# Simulator build
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneSimulator-i386
idz_configure i386 ${IDZ_IOS_SDK_VERSION} $IDZ_LIB_DIR/configure

export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneSimulator-x86_64
idz_configure x86_64 ${IDZ_IOS_SDK_VERSION} $IDZ_LIB_DIR/configure


pushd install-iPhoneSimulator-x86_64/lib
idz_combine $IDZ_LIB_ALL *.a
popd

pushd install-iPhoneSimulator-i386/lib
idz_combine $IDZ_LIB_ALL *.a
popd

pushd install-iPhoneOS-armv7/lib
idz_combine $IDZ_LIB_ALL *.a
popd

pushd install-iPhoneOS-armv7s/lib
idz_combine $IDZ_LIB_ALL *.a
popd

pushd install-iPhoneOS-arm64/lib
idz_combine $IDZ_LIB_ALL *.a
popd

idz_fw $IDZ_FW_NAME $IDZ_LIB_ALL install-iPhoneSimulator-i386/include/$IDZ_NAME

popd
