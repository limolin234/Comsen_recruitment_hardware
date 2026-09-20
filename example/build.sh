#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
toolchain_dir="${ARM_GNU_TOOLCHAIN_HOME:-${project_dir}/../toolchain}"
build_type="${1:-Debug}"
case "${build_type}" in Debug|Release|RelWithDebInfo|MinSizeRel) ;; *) echo "用法：$0 [Debug|Release|RelWithDebInfo|MinSizeRel]" >&2; exit 2;; esac
[[ -f "${toolchain_dir}/env.sh" ]] || { echo "请先在仓库根目录运行 ./setup.sh，或设置 ARM_GNU_TOOLCHAIN_HOME。" >&2; exit 1; }
source "${toolchain_dir}/env.sh"
for command in arm-none-eabi-gcc cmake ninja; do command -v "${command}" >/dev/null 2>&1 || { echo "工具链不完整，请先运行 ./setup.sh。" >&2; exit 1; }; done
cache="${project_dir}/build/${build_type}/CMakeCache.txt"
if [[ -f "${cache}" ]]; then
    recorded_source="$(sed -n 's/^CMAKE_HOME_DIRECTORY:INTERNAL=//p' "${cache}" | head -n 1)"
    [[ -z "${recorded_source}" || "${recorded_source}" == "${project_dir}" ]] || rm -rf -- "${project_dir}/build/${build_type}"
fi
cmake -S "${project_dir}" -B "${project_dir}/build/${build_type}" -G Ninja -DCMAKE_BUILD_TYPE="${build_type}"
cmake --build "${project_dir}/build/${build_type}"
