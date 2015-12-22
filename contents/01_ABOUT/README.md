## 关于SEAndroid

### SEAndroid 是什么

SEAndroid 是从Android 4.4 开始增加的一套强制访问控制
（Mandatory Access Control, MAC），在Android 本身的任意访问控制
（Discretionary Access Control，DAC）之上，通过为对象增加安全上下文的方式，
对访问的权限进行了精确的控制。

SEAndroid 是将SELinux 移植到Android 上的产物，看以看成SELinux 辅以一套适用于
Android 的策略。

### SELinux 是什么

SELinux 是为了实现MAC 而诞生的产物。在SELinux 中，如果想访问一个对象，
首先需要过DAC，然后是MAC 检查，只有全部通过才可以成功访问对象，DAC 是Kernel
本身就有的机制，MAC 则由SELinux 作为一个子系统提供。

#### SELinux 如何工作

SELinux 在内核有一个LSM 模块，用户空间有Security Context、Security Server 和
SEAndroid Policy 模块，用户空间和内核空间通过libselinux 交互。

#### Discretionary Access Control (DAC)

DAC 是Kernel 本身就支持的访问控制机制，通过给文件设置权限位来进行访问的控制。

权限位分为4 个：特殊、用户、组、其他，每个权限位均体现为一个8 进制数字。

特殊位如下：

| 值 | 助记符 |  含义 | 例子 |
| --- | --- | --- | --- |
| 4 | suid | 以文件所属用户（而非当前用户）身份执行 | /usr/bin/passwd |
| 2 | sgid | 以文件所属组身份执行 | /usr/bin/write |
| 1 | sticky | 只能删除该目录下属于自己的文件 | /tmp/ |

其他权限位如下：

| 值 | 助记符 | 含义 |
| --- | --- | --- |
| 4 | w | 写权限 |
| 2 | r | 读权限 |
| 1 | x | 执行权限 |

DAC 需要熟知，因为过DAC 是SELinux 权限检查的必要条件。

#### Mandatory Access Control (MAC)

DAC 检查通过后，会进行MAC 的检查，检查通过SELinux 中对象的安全上下文
（Security Context）进行，下一章会具体说明。

