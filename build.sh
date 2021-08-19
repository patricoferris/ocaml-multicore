#!/bin/sh -e

echo "path(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/lib\"" > ios.conf
echo "destdir(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/lib\"" >> ios.conf
echo "stdlib(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/lib/ocaml\"" >> ios.conf
echo "ocamlopt(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/bin/ocamlopt\"" >> ios.conf
echo "ocamlc(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/bin/ocamlc\"" >> ios.conf
echo "ocamlmklib(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/bin/ocamlmklib\"" >> ios.conf
echo "ocamldep(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/bin/ocamldep\"" >> ios.conf
echo "ocamlcp(ios) = \"${OPAM_SWITCH_PREFIX}/ios-sysroot/bin/ocamlcp\"" >> ios.conf

SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"

OCAML_HOST=$(dirname $(which ocamlrun))/../

STATIC_LIBS="-I $PWD/stdlib -I $PWD/otherlibs/unix"
DYNAMIC_LIBS="-I $OCAML_HOST/lib/ocaml/stublibs"

./configure --host=x86_64-apple-darwin19 --prefix="${OPAM_SWITCH_PREFIX}/ios-sysroot" --disable-ocamldoc --disable-debugger --disable-ocamltest --with-target-bindir="${OPAM_SWITCH_PREFIX}/ios-sysroot/bin" \
   CAMLC_FLAGS="-nostdlib $STATIC_LIBS $DYNAMIC_LIBS" \
   CAMLOPT_FLAGS="-nostdlib $STATIC_LIBS" \
   AS="as -arch x86_64 --target=x86_64-apple-darwin19 -isysroot ${SYSROOT} -miphoneos-version-min=11.4.1" \
   ASPP="clang -arch x86_64 --target=x86_64-apple-darwin19 -isysroot ${SYSROOT} -miphoneos-version-min=11.4.1 -c" \
   CC="clang -arch x86_64 --target=x86_64-apple-darwin19 -isysroot ${SYSROOT} -miphoneos-version-min=11.4.1" \
   PARTIALLD="ld -r -arch x86_64 -syslibroot ${SYSROOT} -platform_version ios-simulator 11.4.1 11.4.1" \
   LD="ld -arch x86_64 -syslibroot ${SYSROOT} -platform_version ios-simulator 11.4.1 11.4.1"

# Tests fail... but I tried to disable them ? 
make -j4 world || true
make -j4 opt
