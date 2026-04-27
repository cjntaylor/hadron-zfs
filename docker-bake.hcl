function "uuid_to_int" {
  params = [id]
  result = parseint("${substr(id, 0, 8)}${substr(id, 9, 4)}${substr(id, 15, 3)}${substr(id, 20, 1)}", 16)
}

function "dynamic_unique_id" {
  params = []
  result = "${uuid_to_int(uuidv4())}"
}

function "static_unique_id" {
  params = []
  result = "3735928559"
}

variable "SOURCE_DATE_EPOCH" {
  default = ""
}

variable "USER" {
  default = "nobody"
}

variable "HOSTNAME" {
  default = "localhost"
}

variable "CACHE_FROM" {
  default = ""
}

variable "RELEASE_VERSION" {
  default = ""
}

variable "CI" {
  default = "false"
}

variable "GITHUB_BASE_REF" {
  default = GITHUB_HEAD_REF
}

variable "GITHUB_HEAD_REF" {
  default = ""
}

variable "GITHUB_REGISTRY" {
  default = "ghcr.io"
}

variable "GITHUB_REPOSITORY" {
  default = "cjntaylor/unset"
}

variable "GITHUB_REPOSITORY_ID" {
  default = static_unique_id()
}

variable "GITHUB_REPOSITORY_OWNER" {
  default = GITHUB_REPOSITORY_ID
}

variable "GITHUB_RUN_ID" {
  default = static_unique_id()
}

variable "GITHUB_SERVER_URL" {
  default = "https://github.com"
}

variable "GITHUB_SHA" {
  default = sha1(static_unique_id())
}

variable "GITHUB_WORKSPACE" {
  default = "."
}

variable "CI_COMMIT_AUTHOR" {
  default = "${USER} <${USER}@${HOSTNAME}>"
}

variable "CI_DEFAULT_BRANCH" {
  default = GITHUB_HEAD_REF
}

variable "CI_COMMIT_BRANCH" {
  default = GITHUB_BASE_REF
}

variable "CI_COMMIT_REF_NAME" {
  default = GITHUB_BASE_REF
}

variable "CI_COMMIT_SHA" {
  default = GITHUB_SHA
}

variable "CI_COMMIT_SHORT_SHA" {
  default = substr(CI_COMMIT_SHA, 0, 7)
}

variable "CI_JOB_ID" {
  default = GITHUB_RUN_ID
}

variable "CI_PROJECT_DIR" {
  default = GITHUB_WORKSPACE
}

variable "CI_PROJECT_ID" {
  default = GITHUB_REPOSITORY_ID
}

variable "CI_PROJECT_NAMESPACE_ID" {
  default = GITHUB_REPOSITORY_OWNER
}

variable "CI_PROJECT_URL" {
  default = "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
}

variable "CI_REGISTRY" {
  default = "${GITHUB_REGISTRY}/${GITHUB_REPOSITORY_OWNER}"
}

variable "CI_REGISTRY_IMAGE" {
  default = "${GITHUB_REGISTRY}/${GITHUB_REPOSITORY_OWNER}"
}

variable "TARGET_PLATFORMS" {
  default = "linux/amd64"
}

variable "BSD_COMPAT_HEADERS_VERSION" {
  validation = {
    condition     = BSD_COMPAT_HEADERS_VERSION != ""
    error_message = "BSD_COMPAT_HEADERS_VERSION is required"
  }
}

variable "HADRON_VERSION" {
  validation = {
    condition     = HADRON_VERSION != ""
    error_message = "HADRON_VERSION is required"
  }
}

variable "HADRON_IMAGE_BASE" {
  validation = {
    condition     = HADRON_IMAGE_BASE != ""
    error_message = "HADRON_IMAGE_BASE is required"
  }
}

variable "HADRON_IMAGE_TRUSTED" {
  validation = {
    condition     = HADRON_IMAGE_TRUSTED != ""
    error_message = "HADRON_IMAGE_TRUSTED is required"
  }
}

variable "HADRON_IMAGE_TOOLCHAIN" {
  validation = {
    condition     = HADRON_IMAGE_TOOLCHAIN != ""
    error_message = "HADRON_IMAGE_TOOLCHAIN is required"
  }
}

variable "HADRON_KERNEL_VERSION" {
  validation = {
    condition     = HADRON_KERNEL_VERSION != ""
    error_message = "HADRON_KERNEL_VERSION is required"
  }
}

variable "HADRON_KERNEL_MAJOR" {
  validation = {
    condition     = HADRON_KERNEL_MAJOR != ""
    error_message = "HADRON_KERNEL_MAJOR is required"
  }
}

variable "HADRON_KERNEL_MINOR" {
  validation = {
    condition     = HADRON_KERNEL_MINOR != ""
    error_message = "HADRON_KERNEL_MINOR is required"
  }
}

variable "HADRON_KERNEL_PATCH" {
  validation = {
    condition     = HADRON_KERNEL_PATCH != ""
    error_message = "HADRON_KERNEL_PATCH is required"
  }
}

variable "LIBTIRPC_VERSION" {
  validation = {
    condition     = LIBTIRPC_VERSION != ""
    error_message = "LIBTIRPC_VERSION is required"
  }
}

variable "OPENZFS_VERSION" {
  validation = {
    condition     = OPENZFS_VERSION != ""
    error_message = "OPENZFS_VERSION is required"
  }
}

function "ref_cache_from" {
  params = [name, tags]
  result = (
    contains(split(",", CACHE_FROM), ref_tag(name, tags)) ?
    ["type=registry,ref=${ref_tag(name, tags)}"]
    : []
  )
}

function "default_cache_to" {
  params = []
  result = ["type=inline"]
}

function "ci_tag" {
  params = [name, tags]
  result = join("/", compact(flatten([
    CI_REGISTRY_IMAGE,
    join(":", compact(flatten([
      [name],
      join("-", compact(flatten([tags])))
    ])))
  ])))
}

function "ref_tag" {
  params = [name, tags]
  result = ci_tag(
    name,
    [
      [tags],
      CI_COMMIT_BRANCH == CI_DEFAULT_BRANCH ?
      ["latest"]
      : ["build", CI_COMMIT_REF_NAME]
    ]
  )
}

function "release_tag" {
  params = [name, tags]
  result = (
    CI_COMMIT_BRANCH == CI_DEFAULT_BRANCH && RELEASE_VERSION != "" ?
    ci_tag(name, [RELEASE_VERSION, [tags]])
    : ""
  )
}

target "project" {
  dockerfile = "Dockerfile"
  cache-to   = default_cache_to()
  context    = "."
  contexts = {
    base      = "docker-image://${HADRON_IMAGE_BASE}:${HADRON_VERSION}"
    trusted   = "docker-image://${HADRON_IMAGE_TRUSTED}:${HADRON_VERSION}"
    toolchain = "docker-image://${HADRON_IMAGE_TOOLCHAIN}:${HADRON_VERSION}"
  }
  args = {
    BSD_COMPAT_HEADERS_VERSION = BSD_COMPAT_HEADERS_VERSION
    CI                         = CI
    CI_COMMIT_AUTHOR           = CI_COMMIT_AUTHOR
    CI_COMMIT_BRANCH           = CI_COMMIT_BRANCH
    CI_COMMIT_REF_NAME         = CI_COMMIT_REF_NAME
    CI_COMMIT_SHA              = CI_COMMIT_SHA
    CI_COMMIT_SHORT_SHA        = CI_COMMIT_SHORT_SHA
    CI_DEFAULT_BRANCH          = CI_DEFAULT_BRANCH
    CI_JOB_ID                  = CI_JOB_ID
    CI_PROJECT_DIR             = CI_PROJECT_DIR
    CI_PROJECT_ID              = CI_PROJECT_ID
    CI_PROJECT_NAMESPACE_ID    = CI_PROJECT_NAMESPACE_ID
    CI_PROJECT_URL             = CI_PROJECT_URL
    CI_REGSITRY                = CI_REGISTRY
    CI_REGISTRY_IMAGE          = CI_REGISTRY_IMAGE
    HADRON_VERSION             = HADRON_VERSION
    HADRON_IMAGE_BASE          = HADRON_IMAGE_BASE
    HADRON_IMAGE_TRUSTED       = HADRON_IMAGE_TRUSTED
    HADRON_IMAGE_TOOLCHAIN     = HADRON_IMAGE_TOOLCHAIN
    HADRON_KERNEL_VERSION      = HADRON_KERNEL_VERSION
    HADRON_KERNEL_MAJOR        = HADRON_KERNEL_MAJOR
    HADRON_KERNEL_MINOR        = HADRON_KERNEL_MINOR
    HADRON_KERNEL_PATCH        = HADRON_KERNEL_PATCH
    LIBTIRPC_VERSION           = LIBTIRPC_VERSION
    OPENZFS_VERSION            = OPENZFS_VERSION
  }
  labels = merge(
    CI_COMMIT_SHA != "" ?
    { "org.opencontainers.image.revision" = "${CI_COMMIT_SHA}" }
    : {},
    RELEASE_VERSION != "" ?
    { "org.opencontainers.image.version" = "${RELEASE_VERSION}" }
    : {},
    CI_PROJECT_URL != "" ?
    { "org.opencontainers.image.url" = "${CI_PROJECT_URL}" }
    : {},
    CI_PROJECT_URL != "" && CI_COMMIT_BRANCH != "" ?
    { "org.opencontainers.image.documentation" = "${CI_PROJECT_URL}/blob/${CI_COMMIT_BRANCH}/README.md" }
    : {},
    CI_COMMIT_AUTHOR != "" ?
    { "org.opencontainers.image.authors" = "${CI_COMMIT_AUTHOR}" }
    : {},
    {
      "org.opencontainers.image.vendor" = "Caynyne Tech"
    }
  )
}

target "hadron-zfs" {
  inherits = ["project"]
  tags = [
    ci_tag("hadron-zfs", [])
  ]
  cache-from = ref_cache_from("hadron-zfs", [])
  platforms  = split(",", TARGET_PLATFORMS)
}

group "default" {
  targets = ["hadron-zfs"]
}
