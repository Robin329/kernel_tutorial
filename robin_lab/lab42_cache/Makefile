# 编译器
CC = gcc

# 编译选项
CFLAGS = -Wall -g -pthread

# 查找当前目录下的所有 C 文件
SOURCES = $(wildcard *.c)

# 生成的可执行文件名，去掉 .c 后缀
EXECUTABLES = $(SOURCES:.c=)

# 默认目标
all: $(EXECUTABLES)

# 为每个 .c 文件生成一个可执行文件
%: %.c
	$(CC) $(CFLAGS) $< -o $@

# 清理目标
clean:
	rm -f $(EXECUTABLES)

# 声明伪目标
.PHONY: all clean
