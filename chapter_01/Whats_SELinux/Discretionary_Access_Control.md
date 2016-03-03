#### Discretionary Access Control (DAC)

DAC 是Kernel 本身就支持的访问控制机制，通过给文件设置权限位来进行访问的控制。

权限位分为4 个：特殊、用户、组、其他，每个权限位均体现为一个8 进制数字。

特殊位如下：

| 值 | 标记 |  含义 | 例子 |
| --- | --- | --- | --- |
| 4 | suid/s | 以文件所属用户（而非当前用户）身份执行 | /usr/bin/passwd |
| 2 | sgid/s | 以文件所属组身份执行 | /usr/bin/write |
| 1 | sticky/t | 只能删除该目录下属于自己的文件 | /tmp/ |

> **suid**/**sgid** 只对可执行文件生效，两者的标记分别显示在属主（owner/o）和
属组（group/g）的位置。sticky 只对目录生效，标记在其他（all users/a）的位置。

其他权限位如下：

| 值 | 标记 | 含义 |
| --- | --- | --- |
| 4 | write/w | 写权限 |
| 2 | read/r | 读权限 |
| 1 | executable/x | 执行权限 |

DAC 需要熟知，因为过DAC 是SELinux 权限检查的必要条件。

