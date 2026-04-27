# Hadron ZFS

[Hadron](https://github.com/kairos-io/hadron) extension image that includes [OpenZFS](https://github.com/openzfs/zfs) kernel modules and userspace applications.

## Building

This project uses [mise](https://mise.jdx.dev) to manage environment variables and to download the required vendor archives before build. If you have mise installed, all that should be required is adding this repository to your [trusted paths](https://mise.jdx.dev/cli/trust.html).

Once the environment is setup correctly, building uses [docker bake](https://docs.docker.com/build/bake/):

```sh
docker buildx bake
```

When using a docker-container [builder](https://docs.docker.com/build/builders/) (the default on many systems, or when using podman), the built images will remain inside the container. Since this project uses multi-architecture builds, the typical `--load` flag will not work (the underlying command `--set=*.output.type=docker` doesn't support loading manifests). There are two options:

### Use the oci output type

```sh
docker buildx bake --set="*.output=type=oci"
```

```sh
docker buildx bake --set="*.output=type=oci,dest=."
```

You may need to include the `dest=` parameter for this to work correctly; if your underlying container runtime is `podman`, the oci-formatted tar this generates will load correctly. Moby/Docker doesn't support OCI tars; specifying `dest=` will write the output tar to the specified directory instead of trying to load the archive

### Publish to a registry

```sh
docker buildx bake --push
```

This will push the resulting images and manifest to the configured container registry. By default, this is set either from the `GITHUB_SERVER_URL` and `GITHUB_REPOSITORY` environment variables, or directly by `CI_REGISTRY_IMAGE`. These values are set appropriately when running locally or on a CI by the [`ci-shim.sh`](.config/mise/ci-shim.sh) loaded by `mise`. You may need to manually set `CI_REGISTRY_IMAGE` to an appropriate value to target a specific registry. Forks of this repository will work correctly out-of-the-box; [`ci-shim.sh`](.config/mise/ci-shim.sh) sets `GITHUB_REPOSITORY` appropriately by parsing the output of `git remote show-url origin`

## Releases

This project builds and publishes containers to GHCR. You can pull or reference the project from here:

```sh
docker pull ghcr.io/cjntaylor/hadron-zfs:latest
```

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
