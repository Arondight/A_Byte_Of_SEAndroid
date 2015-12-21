## 策略部署

### 策略应该写在哪儿

策略的位置可以参考[第二章](../02_BASIC/README.md) 的最后一部分：

1. 对于访问策略，写到相应的`*.te` 文件中，优先考虑第三方配置
+ 对于安全上下文，写到相应的`*_contexts` 文件中，优先考虑第三方配置

### 重新加载策略

1. 修改`*.te` 文件，重新烧写bootimage
+ 修改`*_contexts` 文件，重新烧写systemimage

重新烧image 的一个例子（bootimage）如下：

```shell
make bootimage -j4
adb reboot bootloader
fastboot flash boot out/target/product/scx35l64_sp9838aea_5mod/boot.img
fastboot reboot
```

> 这里有一个例外：recovery 的`*.te` 文件修改需要重新烧写recoveryimage

### 运行模式

SEAndroid 有两种运行模式：

* 强制模式：对于策略禁止的操作打印log 并中止操作
* 宽容模式：对于策略禁止的操作打印log 但**不**中止操作

#### 动态调整

* 强制模式：`setenforce 1`
* 宽容模式：`setenforce 0`

#### 全局调整

### user or userdebug

对于策略的实际检查需要在**user** 版本中进行，相对于userdebug 版本，user 版本
的策略更加齐全。否则可能会遇到发布user 版本时原本通过的策略却出现冲突的情况。

