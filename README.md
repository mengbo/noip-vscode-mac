# 在 macOS 下为 NOIP 搭建编程环境

全国青少年信息学奥林匹克联赛（National Olympiad in Informatics in Provinces，简称NOIP），目前比赛多数使用 C++ 来编写程序，至于编程环境目前多数教练使用 Win 下的 Dev C++ 或者 C-Free，在 macOS 下很多相关书籍建议使用 Xcode 这样复杂的 IDE 来写程序。考虑到孩子在用的旧型号 MacBook Pro 性能不高，Xcode 应该是没法跑了，所以只能配置一个基于 VSCode 下的 C/C++ 开发环境。


当然首先得安装 command line developer tools，命令如下：

```console
$ xcode-select --install
```

至于 VSCode 的安装方法多样，用 Homebrew 的用户可以如下命令安装：

```console
$ brew cask install visual-studio-code
```

安装后需要为 VSCode 安装 Microsoft C/C++ extension for VS Code 这个扩展，这样基本环境就安装完成了。


对于编程环境的配置，首先建立一个工作目录，在里面随便写个程序，例如如：

```C
#include <iostream>

using namespace std;

int main(){
  int a, b;
  cin >> a >> b; 
  cout << a + b << endl;
  return 0;
}
```

然后建立一个内容如下的 Makefile 文件：

```Makefile
CC = clang
CXX = clang++
CFLAGS = -g -Wall
CXXFLAGS = -g -Wall -std=c++11

C_SRCS = $(wildcard *.c) $(wildcard */*.c)
CXX_SRCS = $(wildcard *.cpp) $(wildcard */*.cpp)
C_PROGS = $(patsubst %.c, %, $(C_SRCS))
CXX_PROGS = $(patsubst %.cpp, %, $(CXX_SRCS))
SRCS = $(C_SRCS) $(CXX_SRCS)
PROGS = $(C_PROGS) $(CXX_PROGS)

all: $(PROGS)

clean:
        rm -rf $(PROGS) *.dSYM */*.dSYM
```

此时就可以直接运行 make 命令来编译程序了，这个 Makefile 可以编译当前目录和一级子目录下的所有 C/C++ 程序，并且为了调试方便，调试选项是打开的，make 后可以直接在命令行下用 lldb 来调试了。


命令行下的开发环境配置完毕后，就可以在 VSCode 下配置集成的编译和调试环境了。首先在 VSCode 中打开工作目录，通过【 ⇧⌘P 】打开命令模式执行【 C/Cpp: Select a Configuration… 】命令，选择【 Mac 】，然后再执行【 C/Cpp: Edit Configurations… 】命令在工作目录的 .vscode 配置目录下生成一个 c_cpp_properties.json 文件，在这个文件中需要增加类似如下的 includePath 内容：

```json
{
    "configurations": [
        {
            "...": "...",
            "includePath": [
                "${workspaceFolder}/**",
                "/usr/include",
                "/usr/local/include"
            ],
            "...": "..."
        }
    ],
    "...": "..."
}
```

接下来打开命令模式，执行【 Tasks: Configure Task  】命令，选择【 使用模版创建 tasks.json 文件】，再选择【 Others 】，在工作目录的 .vscode 配置目录下生成 tasks.json 文件，将其修改为类似如下内容：

```json
{
  "...": "...",
  "tasks": [
    {
      "label": "build",
      "type": "shell",
      "command": "make",
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
```

此时就可以通过【 运行 】菜单 【 运行生成任务.. 】功能来编译程序了。

最后，再次打开命令模式执行【 Debug: Open launch.json 】命令，选择【 C++ 】，在工作目录的 .vscode 配置目录下生成 launch.json 文件，修改文件中的相关内容：

```json
{
  "...": "...",
  "configurations": [
    {
      "...": "...",
      "program": "${fileDirname}/${fileBasenameNoExtension}",
      "...": "...",
      "externalConsole": true,
      "...": "...",
      "preLaunchTask": "build"
    }
  ]
}
```

此时就可以正常的调试程序了，并且在调试前，会自动编译。

目前 VSCode 在调试 C/C++ 的时候，只支持弹出一个外部终端窗口来运行程序，需要我们适当的设置断点，避免程序退出后终端窗口立即关闭，以至于我们无法看到程序的输出。


当然还有另外一种思路，即通过 VSCode Code Runner 扩展来直接运行程序，此办法需要修改工作区配置，增加如下内容：

```json
{
    "code-runner.executorMap": {
        "c": "cd $dir && clang -g $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
        "cpp": "cd $dir && clang++ -g $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt"
    },
    "code-runner.runInTerminal": true
}
```

此方法相对方便，但有些剑走偏锋，不建议采用。
