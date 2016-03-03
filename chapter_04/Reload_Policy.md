### 重新加载策略

1. 修改`*.te` 文件，重新烧写bootimage
+ 修改`*_contexts` 文件，重新烧写systemimage

重新烧image 的一个例子（bootimage）如下：

```bash
$ make bootimage -j4
$ adb reboot bootloader
$ sudo fastboot flash boot out/target/product/scx35l64_sp9838aea_5mod/boot.img
$ sudo fastboot reboot
```

> 这里有一个例外：recovery 的`*.te` 文件修改需要重新烧写recoveryimage

