# STM32F103C8 计算器示例工程

这是计算器的 STM32CubeMX CMake 工程，保留了 `.ioc`、CubeMX 生成源码、HAL、
FreeRTOS、USB、启动文件和链接脚本。根目录 `CMakeLists.txt` 沿用 CubeMX 的
原始结构，只将未公开的六个源文件替换为 `lib/` 中对应的静态库。

| 公开头文件 | 对应静态库 |
| --- | --- |
| `calculator_app.h` | `libcalculator_app.a` |
| `calculator_engine.h` | `libcalculator_engine.a` |
| `lcd1602.h` | `liblcd1602.a` |
| `ttp229.h` | `libttp229.a` |
| `touch_filter.h` | `libtouch_filter.a` |
| `touch_model.h` | `libtouch_model.a` |

将独立发布的 `arm-gnu-toolchain-15.2.rel1-linux-x86_64` 解压到本工程同级
目录，然后运行：

```bash
./setup.sh
./build.sh Release
```

产物位于 `build/Release/software.elf`、`.hex` 和 `.bin`。若工具链安装在
其他位置，设置环境变量 `ARM_GNU_TOOLCHAIN_HOME` 为其绝对路径即可。

可用 STM32CubeMX 打开 `software.ioc` 查看或重新生成工程。重新生成后请保留
公开头文件和 `lib/` 中的静态库。
