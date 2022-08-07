### 1.Examples


- 2_tcl_special_var.tcl
在TCL，我们划分一些变量作为特殊变量，他们有一个预定义的用法/功能。特殊变量列表如下。
```tcl
argc
指命令行参数的个数。

argv
指包含命令行参数的列表。

argv0
是指被解释的文件或由调用脚本的名称的文件名。

env
用于表示是环境变量数组元素。

errorCode
为最后的Tcl错误的错误代码。

errorInfo
为最后Tcl错误的堆栈跟踪信息。

tcl_interactive
分别将其设置为1和0交互和非交互模式之间切换。

tcl_library
用于设置的标准Tcl库的位置。

tcl_pkgPath
提供一般都安装包的目录列表。

tcl_patchLevel
指的是Tcl解释目前的补丁级别。

tcl_platform
用于表示使用对象，包括byteOrder, machine, osVersion平台和操作系统数组元素。

tcl_precision
指的是精度，即位数转换为浮点数时，字符串保留。默认值是12。

tcl_prompt1
指的是主提示符。


tcl_prompt2
指无效的命令二次提示。

tcl_rcFileName
为用户提供了具体的启动文件。

tcl_traceCompile
用于控制字节码编译的跟踪。用0表示无输出，1为概要和2为详细。

tcl_traceExec
用于控制执行的字节码的跟踪。用0表示无输出，1为概要和2为详细。

tcl_version
返回Tcl解释器的最新版本。
```


### 2.References
https://wizardforcel.gitbooks.io/tutorialspoint-programming/content/tcl/274.html
https://www.yiibai.com/tcl/tcl_special_variables.html