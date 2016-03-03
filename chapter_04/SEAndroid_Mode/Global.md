#### 全局调整

Android 中提供一个可选的属性`ro.boot.selinux`，这个属性的值可以控制SEAndroid 的开关：

| 值 | SEAndroid 状态 |
| --- | --- |
| *undef* | 强制模式 |
| enforcing | 强制模式 |
| permissive | 宽容模式 |
| disable | 关闭SEAndroid |

可以根据需求来在Makefile 中向bootimage 的default.prop 中写入这个属性来控制SEAndroid。

> *undef* 为未定义，即此属性不存在

