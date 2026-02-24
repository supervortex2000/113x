***开发环境搭建：
    宿主机系统推荐： ubuntu 18.04 20.04 server
    
    Amlogic Linux SDK编译除了依赖python 2.7，make 3.8，git 1.7之外，还需要安装一些额外的软件
包，依赖的软件包安装命令如下 ：
    sudo apt-get install repo git ssh make gcc libssl-dev liblz4-tool expect g++
patchelf chrpath gawk texinfo chrpath diffstat binfmt-support qemu-user-static
live-build bison flex fakeroot cmake gcc-multilib g++-multilib unzip device-tree-
compiler python-pip ncurses-dev pyelftools



***SDK编译
1. 从百度网盘下载SDK： https://pan.baidu.com/s/1g90EWrjdFVqL66ktm0qb_Q    提取码：jiga
   1> 解压 SDK： tar xvf buildroot-openlinux-202307-a113.tar.gz
   2> 解压 dl 到 ~/SDK/buildroot: tar xvf dl-a113-V202307.tar.gz -C ~/SDK/buildroot

2. patch-re下目录文件直接覆盖SDK 对应目录文件

3. 编译步骤：
    1> source buildroot/build/setenv.sh s420
        You're building on Linux
        Lunch menu...pick a combo:
        0. axg_s420_a6432_k54_release
        1. axg_s420_a6432_release

        Which would you like? [-1]      <---输入0

    2> make
       生成img： ~/SDK/output/axg_s420_a6432_k54_release/images/aml_upgrade_package.img











Amlogic Linux SDK编译除了依赖python 2.7，make 3.8，git 1.7之外，还需要安装一些额外的软件
包，依赖的软件包安装命令如下 ：
3.1.4 交叉编译工具链
交叉编译工具由Amlogic提供，位于SDK目录下toolchain中。
3.2 代码下载
sudo apt-get install repo git ssh make gcc libssl-dev liblz4-tool expect g++
patchelf chrpath gawk texinfo chrpath diffstat binfmt-support qemu-user-static
live-build bison flex fakeroot cmake gcc-multilib g++-multilib unzip device-tree-
compiler python-pip ncurses-dev pyelftools
$ repo init -u ssh://git@openlinux.amlogic.com/Buildroot/platform/manifes