variable "REGISTRY" {
  default = "docker.io"
}

variable "IMAGE_VERSION" {
  default = null
}

variable "CONTEXT" {
  default = "."
}

target "python-poetry" {  
  name = "poetry${replace(poetry_version, ".", "-")}-python${replace(python_version, ".", "-")}-${os_variant}"
  context = CONTEXT
  target = "production-image"

  matrix = {
    python_version = ["3.9.18", "3.10.13", "3.11.5"]
    os_variant = ["bookworm", "slim-bookworm"]
    poetry_version = ["1.4.2", "1.5.1", "1.6.1"]
  }
  
  args = {
    POETRY_VERSION = poetry_version
    OFFICIAL_PYTHON_IMAGE = "python:${python_version}-${os_variant}"
  }

  platforms = ["linux/amd64", "linux/arm64/v8"]

  tags = ["${REGISTRY}/pfeiffermax/python-poetry:${IMAGE_VERSION}-poetry${poetry_version}-python${python_version}-${os_variant}"]

  cache-to = [
    "type=gha,mode=max"
  ]

  cache-from = [
    "type=gha"
  ]
}