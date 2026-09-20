#!/usr/bin/env bash

# Source this file from Bash or zsh. It locates itself, so the caller may be in
# any working directory.
if [[ -n "${BASH_VERSION:-}" ]]; then
    _env_file="${BASH_SOURCE[0]}"
elif [[ -n "${ZSH_VERSION:-}" ]]; then
    _env_file="${(%):-%N}"
else
    echo "env.sh supports Bash and zsh." >&2
    return 1 2>/dev/null || exit 1
fi

_tools_dir="$(cd -- "$(dirname -- "${_env_file}")" && pwd -P)"

_prepend_path() {
    case ":${PATH}:" in
        *":$1:"*) ;;
        *) PATH="$1:${PATH}" ;;
    esac
}

_prepend_path "${_tools_dir}/arm-gnu-toolchain-15.2.rel1/bin"
_prepend_path "${_tools_dir}/cmake-4.4.0/bin"
_prepend_path "${_tools_dir}/ninja-1.13.2"
export PATH

unset -f _prepend_path
unset _env_file _tools_dir
