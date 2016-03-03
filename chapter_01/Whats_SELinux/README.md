### SELinux 是什么

SELinux 是为了实现MAC 而诞生的产物。在SELinux 中，如果想访问一个对象，首先需要过DAC，然后是MAC 检查，只有全部通过才可以成功访问对象，DAC 是Kernel本身就有的机制，MAC 则由SELinux 作为一个子系统提供。

