#!/usr/bin/env bash
set -euo pipefail

publish_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
"${publish_dir}/toolchain/setup.sh"
