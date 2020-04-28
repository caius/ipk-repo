#!/usr/bin/env bash

readonly PKG_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/package" >/dev/null 2>&1 && pwd )"

# Read the value of a field out of the control file
control_field() {
  awk -F ': ' '/'$1'/ { print $2 }' ${PKG_ROOT}/control/control
}

readonly PKG_NAME="$(control_field Package)"
readonly PKG_VERSION="$(control_field Version)"
readonly PKG_ARCH="$(control_field Architecture)"

echo "Packaging ${PKG_NAME}.${PKG_VERSION}.${PKG_ARCH}"

find $PKG_ROOT -name \*.tar.gz -delete

pushd $PKG_ROOT/control
gtar --numeric-owner --group=0 --owner=0 -czf ../control.tar.gz ./*
popd

pushd $PKG_ROOT/data
gtar --numeric-owner --group=0 --owner=0 -czf ../data.tar.gz ./*
popd

pushd $PKG_ROOT
gtar --numeric-owner --group=0 --owner=0 -cf $PKG_ROOT/../../packages/${PKG_NAME}_${PKG_VERSION}.${PKG_ARCH}.ipk \
  ./debian-binary ./data.tar.gz ./control.tar.gz
popd

echo "Packaged into packages/${PKG_NAME}_${PKG_VERSION}.${PKG_ARCH}.ipk"
