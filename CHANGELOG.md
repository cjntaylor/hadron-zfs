# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
## [X.Y.Z] - YYYY-MM-DD
### Security
### Fixed
### Changed
### Removed
### Added
### Deprecated
-->

## [Unreleased]

## [0.3.1] - 2026-05-16

### Fixed

- Exclude .gitignore when building the overlay archive

## [0.3.0] - 2026-05-16

### Fixed

- Populate the kernel version URL from the kernel version file
- Cache vendored files separately by version
- Use `${SCCACHE_PATH}` to invoke sccache when compiling
- Use correct architecture when building riscv64
- Publish tags during build

### Changed

- Updated Hadron to [v0.2.0](https://github.com/kairos-io/hadron/releases/tag/v0.2.0)
  - riscv64 is now published in the multi-architecture manifest

- Updated OpenZFS to [2.4.2](https://github.com/openzfs/zfs/releases/tag/zfs-2.4.2)

## [0.2.0] - 2026-04-28

### Changed

- Switched to building via github action / [act](https://nektosact.com/). Simplifies cross-platform building to run on the architecture of the runner

### Removed

- Docker-based build system. Superceeded by the action-based build; previous release still has the implementation if needed

## [0.1.0] - 2026-04-27

### Added

- Initial commit
