#!/bin/sh
[ ! -r env/ci-shim ] || . env/ci-shim
[ -z "${CI_VERSION}" ] || [ ! "${CI_VERSION_PREV}" = "${HADRON_ZFS_VERSION}" ] || exit 0

export CI_VERSION_PREV="${HADRON_ZFS_VERSION}"
export CI_VERSION="${HADRON_ZFS_VERSION}"
export CI_COMMIT_AUTHOR="$(git config user.name) <$(git config user.email)>"
cat <<EOF >env/ci-shim
CI_VERSION_PREV="${CI_VERSION_PREV}"
CI_VERSION="${CI_VERSION}"
CI_COMMIT_AUTHOR="${CI_COMMIT_AUTHOR}"
EOF

[ -n "${GITHUB_BASE_REF}"   ] || GITHUB_BASE_REF="$(git branch --show-current)"
[ -n "${GITHUB_HEAD_REF}"   ] || GITHUB_HEAD_REF="$(git branch --show-current)"
if [ -z "${GITHUB_REPOSITORY}" ]; then
  GITHUB_REPOSITORY="$(git remote get-url origin)"
  GITHUB_REPOSITORY="${GITHUB_REPOSITORY#*:}"
  GITHUB_REPOSITORY="${GITHUB_REPOSITORY%%.*}"
fi
[ -n "${GITHUB_REPOSITORY_OWNER}" ] || GITHUB_REPOSITORY_OWNER="${GITHUB_REPOSITORY%%/*}"
if [ -z "${GITHUB_SHA}" ] && git rev-parse HEAD 2>/dev/null 1>&2; then
  export GITHUB_SHA="$(git rev-parse HEAD)"
  cat <<-EOF >>env/ci-shim
	GITHUB_SHA="${GITHUB_SHA}"
	EOF
fi
[ -n "${GITHUB_WORKSPACE}" ] || GITHUB_WORKSPACE="$(readlink -f ../..)"

export GITHUB_BASE_REF GITHUB_HEAD_REF GITHUB_REPOSITORY GITHUB_REPOSITORY_OWNER GITHUB_WORKSPACE

cat <<EOF >>env/ci-shim
GITHUB_BASE_REF="${GITHUB_BASE_REF}"
GITHUB_HEAD_REF="${GITHUB_HEAD_REF}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY}"
GITHUB_REPOSITORY_OWNER="${GITHUB_REPOSITORY_OWNER}"
GITHUB_WORKSPACE="${GITHUB_WORKSPACE}"
EOF
