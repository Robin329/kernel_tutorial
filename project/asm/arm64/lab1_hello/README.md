```bash
# preprocessing
$ aarch64-linux-gnu-gcc -E hello_world.c -o hello_world.i

$ stat hello_world.i
  File: test.i
  Size: 30934           Blocks: 64         IO Block: 4096   regular file
Device: 803h/2051d      Inode: 416058      Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/   robin)   Gid: ( 1000/   robin)
Access: 2022-07-27 17:12:37.511413818 +0800
Modify: 2022-07-27 17:12:37.443413781 +0800
Change: 2022-07-27 17:12:37.443413781 +0800
 Birth: 2022-07-27 17:12:37.435413777 +0800

# compile
$ aarch64-linux-gnu-gcc -S hello_world.i -o hello_world.s


# assemble
$ aarch64-linux-gnu-gcc -c hello_world.s -o hello_world.o

# Links
$ aarch64-linux-gnu-gcc hello_world.o -o hello_world
```