# Hadron ZFS

[Hadron](https://github.com/kairos-io/hadron) overlay that includes [OpenZFS](https://github.com/openzfs/zfs) kernel modules and userspace applications.

## Building

This project uses [GitHub Actions](https://docs.github.com/en/actions) to build and publish overlay archives. This can be tested locally via [act](https://nektosact.com/):

```sh
act -s GITHUB_TOKEN="$(gh auth token)"
```

The GITHUB_TOKEN must be set to a valid token to support the [Sccache Action](https://github.com/marketplace/actions/sccache-action) - the job will fail without it. This functionality was retained even locally because of how much time it saves; all other non-local steps are disabled when running via act.

## Releases

This project builds and publishes overlay archives via the action workflow to [releases](https://github.com/cjntaylor/hadron-zfs/releases). Each release will contain one overlay archive per supported architecture. Currently, the project is built for `amd64`, `arm64` and `riscv64`

## Changelog

This project maintains a changelog in [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format in [CHANGELOG.md](./CHANGELOG.md)

## License

This project is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license; see the [LICENSE.md](./LICENSE.md) file for details.

> [!IMPORTANT] All files in this project have the following declaration:
>
> Copyright 2026 Colin Taylor
>
> Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
>
> http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

This project has several dependencies, each with their own license:

| Project                                                                                                  | License                                                                                  |
| -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| [Hadron](https://github.com/kairos-io/hadron)                                                            | [Apache-2.0](https://github.com/kairos-io/hadron#license)                                |
| [linux](https://kernel.org/)                                                                             | [GPL-2.0 WITH Linux-syscall-note](https://github.com/torvalds/linux/blob/master/COPYING) |
| [bsd-compat-headers](https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/bsd-compat-headers) | [Artistic-1.0-cl8](https://github.com/anoraktrend/bheaded/blob/main/LICENSE)             |
| [libtirpc](https://www.linuxfromscratch.org/blfs/view/svn/basicnet/libtirpc.html)                        | [BSD-3-Clause](https://github.com/couchbasedeps/libtirpc/blob/master/COPYING)            |
| [OpenZFS](https://github.com/openzfs/zfs)                                                                | [CDDL-1.0](https://github.com/openzfs/zfs/blob/master/LICENSE)                           |

## Contributors

This project was created and is maintained by [Colin Taylor](https://github.com/cjntaylor).

Special thanks to all the amazing people at [Kairos](https://kairos.io/) and [OpenZFS](https://openzfs.org/) for the excellent framework and tools :smiling_face_with_three_hearts:
