#!/bin/sh
[ ! -r env/openzfs ] || . env/openzfs
[ -z "${OPENZFS_VERSION}" ] || [ ! "${OPENZFS_VERSION_PREV}" = "${OPENZFS_VERSION}" ] || exit 0

export OPENZFS_VERSION_PREV="${OPENZFS_VERSION}"

# Update the vendored zfs
(
  cd "../../vendor"
  find -name "zfs-*.tar.gz" -delete
  http -F -d \
    -o "zfs-${OPENZFS_VERSION}.tar.gz" \
    "https://github.com/openzfs/zfs/releases/download/zfs-${OPENZFS_VERSION}/zfs-${OPENZFS_VERSION}.tar.gz"
)

cat <<EOF >env/openzfs
OPENZFS_VERSION_PREV="${OPENZFS_VERSION}"
OPENZFS_VERSION="${OPENZFS_VERSION}"
EOF
