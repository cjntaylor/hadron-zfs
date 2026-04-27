#!/bin/sh
[ ! -r env/libtirpc ] || . env/libtirpc
[ -z "${LIBTIRPC_VERSION}" ] || [ ! "${LIBTIRPC_VERSION_PREV}" = "${LIBTIRPC_VERSION}" ] || exit 0

export LIBTIRPC_VERSION_PREV="${LIBTIRPC_VERSION}"

# Update the vendored libtirpc
(
  cd "../../vendor"
  find -not -name "libtirpc-${LIBTIRPC_VERSION}.tar.bz2" -a -name "libtirpc-*.tar.bz2" -delete
  [ -r "libtirpc-${LIBTIRPC_VERSION}.tar.bz2" ] \
    || http -F -d --ignore-stdin \
    -o "libtirpc-${LIBTIRPC_VERSION}.tar.bz2" \
    "https://downloads.sourceforge.net/libtirpc/libtirpc-${LIBTIRPC_VERSION}.tar.bz2"
)

cat <<EOF >env/libtirpc
LIBTIRPC_VERSION_PREV="${LIBTIRPC_VERSION}"
LIBTIRPC_VERSION="${LIBTIRPC_VERSION}"
EOF
