## 策略部署

### 策略的位置

策略的位置可以参考[第二章](../02_BASIC/README.md) 的最后一部分：

1. 对于访问策略，写到相应的`*.te` 文件中，优先考虑第三方配置
+ 对于安全上下文，写到相应的`*_contexts` 文件中，优先考虑第三方配置

### 策略文件不存在

如果需要新建一个策略文件，那么除了需要写入策略，还需要修改Makefile 以便能够
让策略被正确编译。

在文件`BoardConfigCommon.mk` 中查找`BOARD_SEPOLICY_UNION` 变量，修改它的值以
包含新增的策略文件，然后再编译对应的image。

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

Android 中提供一个可选的属性`ro.boot.selinux`，
这个属性的值可以控制SEAndroid 的开关：

| 值 | SEAndroid 状态 |
| --- | --- |
| *undef* | 强制模式 |
| enforcing | 强制模式 |
| permissive | 宽容模式 |
| disable | 关闭SEAndroid |

可以根据需求来在Makefile 中向bootimage 的default.prop 中写入这个属性来控制
SEAndroid。

> *undef* 为未定义，即此属性不存在

### user or userdebug

对于策略的实际检查需要在**user** 版本中进行，相对于userdebug 版本，user 版本
的策略更加齐全。否则可能会遇到发布user 版本时原本通过的策略却出现冲突的情况。

