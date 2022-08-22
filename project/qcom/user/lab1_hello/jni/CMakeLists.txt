cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_COMPILER /home/robin/Android/Sdk/ndk/24.0.8215888/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++)

project(hello CXX)

set(CMAKE_CXX_FLAGS "--target=aarch64-none-linux-android30 --gcc-toolchain=/home/robin/Android/Sdk/ndk/24.0.8215888/toolchains/llvm/prebuilt/linux-x86_64 --sysroot=/home/robin/Android/Sdk/ndk/24.0.8215888/toolchains/llvm/prebuilt/linux-x86_64/sysroot")

set(SOURCES
        hello.cpp
)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++")
add_executable(hello_cmake ${SOURCES})
