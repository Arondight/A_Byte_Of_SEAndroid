### 策略文件不存在

如果需要新建一个策略文件，那么除了需要写入策略，还需要修改Makefile 以便能够让策略被正确编译。

在文件`BoardConfigCommon.mk` 中查找`BOARD_SEPOLICY_UNION` 变量，修改它的值以包含新增的策略文件，然后再编译对应的image。

