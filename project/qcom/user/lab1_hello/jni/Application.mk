NDK_PROJECT_PATH=$(shell pwd)
# APP_STL := c++_shared
APP_STL += c++_static
APP_CPPFLAGS := -frtti -fexceptions
APP_CPPFLAGS +=-std=c++11 #允许使用c++11的函数等功能
APP_PLATFORM := android-30
APP_ABI := arm64-v8a
