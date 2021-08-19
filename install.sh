#!/bin/sh -e
cp "${OPAM_SWITCH_PREFIX}/bin/ocamlrun" runtime
# cp "${OPAM_SWITCH_PREFIX}/bin/ocamlrund" runtime
# cp "${OPAM_SWITCH_PREFIX}/bin/ocamlruni" runtime
make install
#added seq only
for pkg in bigarray bytes compiler-libs dynlink findlib seq stdlib str threads unix; do
  cp -r "${OPAM_SWITCH_PREFIX}/lib/${pkg}" "${OPAM_SWITCH_PREFIX}/ios-sysroot/lib/"
done
sed -i -e 's/unix//g' ${OPAM_SWITCH_PREFIX}/ios-sysroot/lib/bigarray/META
ln -sf "${OPAM_SWITCH_PREFIX}/bin/ocamlrun" "${OPAM_SWITCH_PREFIX}/ios-sysroot/bin/ocamlrun"
mkdir -p "${OPAM_SWITCH_PREFIX}/lib/findlib.conf.d"
cp ios.conf "${OPAM_SWITCH_PREFIX}/lib/findlib.conf.d"