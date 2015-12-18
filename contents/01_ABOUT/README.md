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

#### Discretionary Access Control (DAC)

#### Mandatory Access Control (MAC)

