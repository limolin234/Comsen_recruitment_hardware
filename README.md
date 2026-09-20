# Comsen 实验室硬件组招新：做一台 STM32 计算器

本题面向大一、大二同学。从焊接和点亮屏幕开始，逐步实现触摸按键、串口显示和计算器功能，做出一台可以实际使用的计算器。

我们提供可运行的计算器示例和相关库，供大家验证硬件、体验效果，并在此基础上按自己的兴趣逐步复现。可以先借助已有库完成一条可运行的流程，再选择其中的模块自己实现。

## 硬件与使用提醒

开发板采用 STM32F103C8T6 核心板、1602 字符液晶屏和两颗 TTP229 电容触摸芯片，共使用 30 个触摸按键，通过核心板的 Type-C 接口供电。

**板子背面也可能感应到手部接近，引发误触。建议用纸壳等非导电支撑物将板子垫高，使手与背面触摸区域保持一定距离；垫层过薄时仍可能触发。** 纸壳主要通过增加距离减弱电容耦合，并不是屏蔽层；电容触摸本来就能隔着绝缘材料工作。上电和测试时尽量保持放置条件稳定。

## 招新任务

按下面的顺序逐步完成，也可以根据自己的基础选择重点。

| 阶段 | 任务 | 可以学到什么 |
| --- | --- | --- |
| 1. 硬件基础 | 完成开发板焊接，检查供电和连接，用提供的示例验证显示与按键 | 焊接、硬件检查和调试 |
| 2. 串口与显示 | 使用 STM32 USB 虚拟串口，将电脑发送的信息显示到屏幕上 | USB CDC、数据接收、字符显示 |
| 3. 触摸按键 | 自己实现按键读取，实时显示按下的按键 | GPIO、时序、位图和输入处理 |
| 4. 基本计算器 | 实现不带括号的四则运算与 AC 清空 | 输入组织、运算处理、交互逻辑 |
| 5. 函数扩展 | 支持括号解析和特殊函数 | 表达式解析与数学函数 |
| 6. 自选提高 | 支持复数运算或其他自己感兴趣的功能 | 功能设计与综合实现 |

大一建议完成 1–4，大二建议完成 1–6。如果暂时不擅长按键驱动，可以先使用提供的库，继续完成自己更擅长的计算或交互部分，并说明哪些模块是自己实现的。

本板 TTP229 使用 GPIO 实现两线读出时序，**不是标准 I²C 外设读写**；请结合芯片资料理解协议。1602 是两行、每行 16 个字符的字符屏，请按字符显示能力设计界面。

## 推荐实现方式

`example/` 使用 FreeRTOS，将按键、计算、控制和显示放在不同任务中。这是示例的实现选择，**不要求大家使用 RTOS，也不要求照搬示例架构**。

推荐先用更简单的裸机程序：完成初始化后，在 `while (1)` 中依次处理按键、接收串口数据、更新计算状态和刷新屏幕。可以用定时器或系统节拍控制扫描间隔，先让基本功能运行起来，再逐步扩展。

可以按个人偏好复现部分模块，例如：保留显示和按键库，自己实现计算器；保留计算核心，自己实现按键和界面；或者逐步替换全部模块。提交时请提供自己编写的源码，并说明已完成功能、使用了哪些提供的库，以及仍存在的问题。

## 我们提供什么

- 可运行的 STM32CubeMX 示例工程和公开头文件、静态库。
- 独立发布的 Arm GNU Toolchain 编译环境，多个工程可以共用。
- 工程的 `.ioc` 配置，供大家查看引脚、时钟和外设设置，并学习如何自行配置。

本仓库提供上述软件资料；不附带 PCB/BOM 文件、独立硬件自检程序、烧录软件或 CubeMX 安装包。文件结构如下：

```text
.
├── README.md                         # 本项目编写：招新题目和使用说明
├── example/                          # 可直接编译的计算器示例
│   ├── software.ioc                  # CubeMX 保存的配置，是重新生成的输入
│   ├── Core/Inc/                     # CubeMX 生成的头文件 + 本项目添加的库接口
│   ├── Core/Src/                     # CubeMX 生成的初始化/任务骨架，USER CODE 内有示例代码
│   ├── Drivers/                      # CubeMX 按配置复制的上游 HAL、CMSIS 文件
│   ├── Middlewares/                  # CubeMX 按配置复制的上游 FreeRTOS、USB 库
│   ├── USB_DEVICE/                   # CubeMX 生成的 USB 接口，USER CODE 内有项目修改
│   ├── cmake/
│   │   ├── stm32cubemx/CMakeLists.txt # CubeMX 生成：所选外设/中间件的源码与包含路径
│   │   └── gcc-arm-none-eabi.cmake    # CubeMX 生成的基础上调整：编译器、编译/链接参数
│   ├── CMakeLists.txt                # CubeMX 初次生成，本项目补充静态库链接和 HEX/BIN 输出
│   ├── CMakePresets.json             # CubeMX 预设基础上补充构建配置
│   ├── startup_stm32f103xb.s         # CubeMX 提供的启动汇编
│   ├── stm32f103c8tx_flash.ld         # CubeMX 提供的链接脚本，本项目调整过堆配置
│   ├── lib/                          # 本项目提供：各模块的预编译静态库
│   ├── README.md                     # 本项目编写：示例使用说明
│   ├── setup.sh                      # 本项目编写：初始化共享工具链
│   └── build.sh                      # 本项目编写：编译当前工程
└── toolchain/                        # 本项目整理的安装脚本与说明，不由 CubeMX 生成
```

CubeMX 负责根据 `.ioc` 生成初始化代码和构建所需的底层文件，不会生成本项目的计算器、显示或触控库。`Core/Inc/` 中的 `calculator_*.h`、`lcd1602.h`、`ttp229.h`、`touch_*.h` 是我们额外提供的公开接口。重新生成时，USER CODE 区域之外的自动生成代码可能被覆盖；新增代码应放在 USER CODE 区域或自己的独立源文件中。

## 编译示例

工具包用于 x86_64 Linux / WSL Ubuntu。当前已在 Ubuntu 24.04 上验证；Ubuntu 20.04 的完整环境验证尚未完成。

从仓库 Release 下载 `arm-gnu-toolchain-15.2.rel1-linux-x86_64.tar.gz`，解压后将工具链目录放在 `example/` 同级：

```text
仓库目录/
├── example/
├── toolchain/
└── arm-gnu-toolchain-15.2.rel1-linux-x86_64/
```

在仓库根目录打开终端，运行：

```bash
cd example
./setup.sh
./build.sh Release
```

`setup.sh` 校验并解压工具；正常安装不需要 sudo。缺少基础解压工具时，在 Ubuntu 中安装：

```bash
sudo apt-get install tar xz-utils gzip python3 coreutils curl
```

编译成功后，在 `example/build/Release/` 中获得 `software.elf`、`software.hex` 和 `software.bin`。脚本只编译，不自动烧录；使用对应烧录工具写入开发板后才能看到屏幕和按键效果。若用 BIN 文件写入内部 Flash，起始地址为 `0x08000000`。

不传参数的 `./build.sh` 默认构建 Debug。工具链如果已经安装在别处，可以共用它：

```bash
export ARM_GNU_TOOLCHAIN_HOME=/实际路径/arm-gnu-toolchain-15.2.rel1-linux-x86_64
./setup.sh
./build.sh Release
```

详细说明见 [示例工程说明](example/README.md) 和 [工具链说明](toolchain/README.md)。示例默认运行计算器，没有启动 USB CDC；第 2 项串口任务需要自行配置和启用。

## 使用库与自行复现

头文件位于 `example/Core/Inc/`，对应静态库位于 `example/lib/`：

| 头文件 / 静态库名称 | 功能 | 裸机复用说明 |
| --- | --- | --- |
| `calculator_engine.h` / `libcalculator_engine.a` | 表达式计算 | 可独立调用，链接时需要数学库 `m` |
| `lcd1602.h` / `liblcd1602.a` | LCD 字符显示 | 依赖本板 GPIO、HAL 和 TIM3 |
| `ttp229.h` / `libttp229.a` | 读取 30 位物理按键状态 | 依赖本板 GPIO 和 TIM3 |
| `touch_filter.h` / `libtouch_filter.a` | 按键滤波 | 可用于裸机，按接口约定每 10 ms 更新 |
| `touch_model.h` / `libtouch_model.a` | 触摸组合识别 | 可用于裸机，内含已有板子的默认模型 |
| `calculator_app.h` / `libcalculator_app.a` | 示例的任务和应用逻辑 | 依赖 FreeRTOS；裸机复刻时自行编写这部分 |

这些预编译库按当前 STM32F103 Cortex-M3 配置生成。复用 LCD 和触摸驱动时，需保持示例引脚分配，提供 `htim3`，将 TIM3 配为 1 MHz 计数并在调用驱动前启动；LCD 还需要可工作的 HAL 毫秒时基。换引脚或改变底层配置时，应自行实现对应驱动。

推荐用 CubeMX 新建自己的裸机工程，选择 CMake 输出，配置好硬件后仅加入需要的头文件和静态库。自己实现某模块后，从链接列表中移除对应 `.a`，加入自己的 `.c`。不要同时保留同名实现与原库，以免链接结果不符合预期。

可以打开示例的 `software.ioc` 查看配置。重新生成时启用保留 USER CODE，保留公开头文件、`lib/` 和根 CMake 中的静态库链接配置；初始化和回调代码写在 USER CODE 区域。修改 RTOS、GPIO 或定时器配置时，也应同步调整调用这些模块的代码。
