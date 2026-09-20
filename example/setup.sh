#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
toolchain_dir="${ARM_GNU_TOOLCHAIN_HOME:-${project_dir}/../arm-gnu-toolchain-15.2.rel1-linux-x86_64}"
[[ -x "${toolchain_dir}/setup.sh" ]] || { echo "未找到共享工具链：${toolchain_dir}" >&2; exit 1; }
"${toolchain_dir}/setup.sh"
