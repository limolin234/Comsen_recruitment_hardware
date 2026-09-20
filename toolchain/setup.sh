#!/usr/bin/env bash
set -euo pipefail

tools_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
downloads_dir="${tools_dir}/downloads"

arm_version="15.2.rel1"
cmake_version="4.4.0"
ninja_version="1.13.2"

require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Missing host command: $1" >&2
        exit 1
    }
}

verify() {
    printf '%s  %s\n' "$1" "$2" | sha256sum --check --status -
}

download() {
    local url="$1" archive="$2" checksum="$3"
    if [[ -f "${archive}" ]] && verify "${checksum}" "${archive}"; then
        echo "Using cached $(basename -- "${archive}")"
        return
    fi
    require_command curl
    rm -f -- "${archive}" "${archive}.part"
    echo "Downloading $(basename -- "${archive}")"
    curl --proto '=https' --tlsv1.2 --fail --location --retry 3 \
        --output "${archive}.part" "${url}"
    verify "${checksum}" "${archive}.part"
    mv -- "${archive}.part" "${archive}"
}

extract_tar() (
    local archive="$1" destination="$2" compression="$3"
    local temporary
    temporary="$(mktemp -d "${tools_dir}/.extract.XXXXXX")"
    trap 'rm -rf -- "${temporary}"' EXIT INT TERM
    tar "-${compression}f" "${archive}" --strip-components=1 -C "${temporary}"
    mv -- "${temporary}" "${destination}"
    trap - EXIT INT TERM
)

if [[ "$(uname -s)" != Linux || "$(uname -m)" != x86_64 ]]; then
    echo "此工具包仅支持 x86_64 Linux 和 x86_64 WSL。" >&2
    exit 1
fi
require_command tar
require_command python3
require_command sha256sum
require_command mktemp
mkdir -p -- "${downloads_dir}"

install_arm() {
    local archive="${downloads_dir}/arm-gnu-toolchain-${arm_version}-x86_64-arm-none-eabi.tar.xz"
    local destination="${tools_dir}/arm-gnu-toolchain-${arm_version}"
    [[ -x "${destination}/bin/arm-none-eabi-gcc" ]] && return
    [[ ! -e "${destination}" ]] || { echo "Incomplete directory: ${destination}" >&2; exit 1; }
    download "https://developer.arm.com/-/media/Files/downloads/gnu/${arm_version}/binrel/$(basename -- "${archive}")" "${archive}" "597893282ac8c6ab1a4073977f2362990184599643b4c5ee34870a8215783a16"
    extract_tar "${archive}" "${destination}" xJ
}

install_cmake() {
    local archive="${downloads_dir}/cmake-${cmake_version}-linux-x86_64.tar.gz"
    local destination="${tools_dir}/cmake-${cmake_version}"
    [[ -x "${destination}/bin/cmake" ]] && return
    [[ ! -e "${destination}" ]] || { echo "Incomplete directory: ${destination}" >&2; exit 1; }
    download "https://github.com/Kitware/CMake/releases/download/v${cmake_version}/$(basename -- "${archive}")" "${archive}" "3864eb649b4466ae126a64bbde1657adad78efbbaa068bf38201de5cf1b5349f"
    extract_tar "${archive}" "${destination}" xz
}

install_ninja() {
    local archive="${downloads_dir}/ninja-linux.zip"
    local destination="${tools_dir}/ninja-${ninja_version}"
    local temporary
    [[ -x "${destination}/ninja" ]] && return
    [[ ! -e "${destination}" ]] || { echo "Incomplete directory: ${destination}" >&2; exit 1; }
    download "https://github.com/ninja-build/ninja/releases/download/v${ninja_version}/ninja-linux.zip" "${archive}" "5749cbc4e668273514150a80e387a957f933c6ed3f5f11e03fb30955e2bbead6"
    temporary="$(mktemp -d "${tools_dir}/.extract.XXXXXX")"
    trap 'rm -rf -- "${temporary}"' EXIT INT TERM
    python3 -m zipfile -e "${archive}" "${temporary}"
    chmod +x "${temporary}/ninja"
    mv -- "${temporary}" "${destination}"
    trap - EXIT INT TERM
}

install_arm
install_cmake
install_ninja
source "${tools_dir}/env.sh"
arm-none-eabi-gcc --version | head -n 1
cmake --version | head -n 1
ninja --version
