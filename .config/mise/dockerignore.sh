#!/bin/sh
[ ! -r env/dockerignore ] || . env/dockerignore
[ ! "${DOCKERIGNORE_HADRON_KERNEL_VERSION}" = "${HADRON_KERNEL_VERSION}" ] \
  || [ ! "${DOCKERIGNORE_BSD_COMPAT_HEADERS}" = "${BSD_COMPAT_HEADERS_VERSION}" ] \
  || [ ! "${DOCKERIGNORE_LIBTIRPC}" = "${LIBTIRPC_VERSION}" ] \
  || [ ! "${DOCKERIGNORE_OPENZFS}" = "${OPENZFS_VERSION}" ] \
  || exit 0

export DOCKERIGNORE_HADRON_KERNEL_VERSION="${HADRON_KERNEL_VERSION}"
export DOCKERIGNORE_BSD_COMPAT_HEADERS_VERSION="${BSD_COMPAT_HEADERS_VERSION}"
export DOCKERIGNORE_LIBTIRPC_VERSION="${LIBTIRPC_VERSION}"
export DOCKERIGNORE_OPENZFS_VERSION="${OPENZFS_VERSION}"

cat <<EOF >env/dockerignore
DOCKERIGNORE_HADRON_KERNEL_VERSION="${DOCKERIGNORE_HADRON_KERNEL_VERSION}"
DOCKERIGNORE_BSD_COMPAT_HEADERS_VERSION="${DOCKERIGNORE_BSD_COMPAT_HEADERS_VERSION}"
DOCKERIGNORE_LIBTIRPC_VERSION="${DOCKERIGNORE_LIBTIRPC_VERSION}"
DOCKERIGNORE_OPENZFS_VERSION="${DOCKERIGNORE_OPENZFS_VERSION}"
EOF

cat <<EOF >../../.dockerignore
###################################################################################################
# Generated dockerignore file - DO NOT EDIT
###################################################################################################

# Whitelist by default
*

# Include vendored archives
!/vendor
/vendor/*
!/vendor/bsd-compat-headers-${BSD_COMPAT_HEADERS_VERSION}.tar
!/vendor/libtirpc-${LIBTIRPC_VERSION}.tar.bz2
!/vendor/linux-${HADRON_KERNEL_VERSION}.tar.xz
!/vendor/zfs-${OPENZFS_VERSION}.tar.gz
EOF
