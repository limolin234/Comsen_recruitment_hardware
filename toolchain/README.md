# x86_64 Linux 的 Arm GNU Toolchain 构建环境

这是面向裸机 32 位 Arm 固件的上游构建环境。包内附带安装脚本与已固定校验值的上游
归档：

- Arm GNU Toolchain 15.2.Rel1，目标三元组为 `arm-none-eabi`；
- CMake 4.4.0；
- Ninja 1.13.2。

支持 x86_64 Linux 和 x86_64 Ubuntu WSL。每个项目自行选择正确的 `-mcpu`、FPU
ABI、启动文件与链接脚本后，编译器可用于 Cortex-M0/M0+/M3/M4/M7。它不适用于
运行 Linux 的 Cortex-A STM32MP 系列。

将工具链包解压到稳定的个人目录后，仅需安装一次：

```bash
./setup.sh
```

不需要管理员权限，不会安装或修改系统软件。 `setup.sh` 会先校验每份上游归档的
SHA256，再解压。它需要 `tar`、`python3`、`sha256sum` 和 `mktemp`；
只有 `downloads/` 中缺少归档时才需要 `curl`。

每个要编译固件的终端中，无论当前目录在哪里，都执行：

```bash
source /absolute/path/to/arm-gnu-toolchain-15.2.rel1-linux-x86_64/env.sh
```

这会把 `arm-none-eabi-gcc`、`arm-none-eabi-objcopy`、CMake 和 Ninja 加入当前
终端的 `PATH`，不会修改系统或 shell 启动文件。

对于 CMake 文件使用 `arm-none-eabi-gcc` 的 CubeMX 工程，接着按工程自己的命令
构建，例如：

```bash
cmake -S . -B build/Debug -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build/Debug
```
