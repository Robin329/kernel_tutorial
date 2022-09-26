### 1. NDK build
```bash
# Under hello directory, then run:
$ ndk-build
# You need to add the NDK path to you system environment.
```
- Android Run result:
```bash
crosshatch:/data # chmod a+x hello_ndk_build && ./hello_ndk_build
hello, world!
```



### 2. CMAKE build
```bash
$ cd build
$ cmake ../
$ make
```
- Android Run result:
```bash
crosshatch:/data # chmod a+x hello_cmake && ./hello_cmake
hello, world!
```

### 3. Makefile
```bash
$ make
```
- Android Run result:
```bash
crosshatch:/data # chmod a+x hello_make && ./hello_make
hello, world!
```
