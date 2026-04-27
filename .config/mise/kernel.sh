#!/bin/sh
[ ! -r env/kernel ] || . env/kernel
[ -z "${HADRON_KERNEL_VERSION}" ] || [ ! "${HADRON_VERSION_KERNEL}" = "${HADRON_VERSION}" ] || exit 0

# Generate kernel version parameters
export HADRON_KERNEL_VERSION=$(docker run --rm ${HADRON_IMAGE_TOOLCHAIN}:${HADRON_VERSION} cat /usr/share/kernel-misc/kernel-version)
export HADRON_KERNEL_MAJOR=${HADRON_KERNEL_VERSION%%.*}
export HADRON_KERNEL_MINOR=${HADRON_KERNEL_VERSION#*.}
export HADRON_KERNEL_MINOR=${HADRON_KERNEL_MINOR%%.*}
export HADRON_KERNEL_PATCH=${HADRON_KERNEL_VERSION##*.}

# Update the vendored kernel
(
  cd "../../vendor"
  find -not -name "linux-${HADRON_KERNEL_VERSION}.tar.xz" -a -name "linux-*.tar.xz" -delete
  [ -r "linux-${HADRON_KERNEL_VERSION}.tar.xz" ] \
    || http -F -d --ignore-stdin \
    -o "linux-${HADRON_KERNEL_VERSION}.tar.xz" \
    "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${HADRON_KERNEL_VERSION}.tar.xz"
)

cat <<EOF >env/kernel
HADRON_VERSION_KERNEL="${HADRON_VERSION}"
HADRON_KERNEL_VERSION="${HADRON_KERNEL_VERSION}"
HADRON_KERNEL_MAJOR="${HADRON_KERNEL_MAJOR}"
HADRON_KERNEL_MINOR="${HADRON_KERNEL_MINOR}"
HADRON_KERNEL_PATCH="${HADRON_KERNEL_PATCH}"
EOF
