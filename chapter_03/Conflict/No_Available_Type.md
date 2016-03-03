#### 无可用的客体类型

如果第一步找不到可以操作的设备类型，那么就需要自己增加一个可用的类型。假设这个设备的类型为`my_type`，可以通过如下的方法实现：

1. 添加`type` 语句
    `type   my_type dev_type`
+ 为这个类型增加`allow` 语句
    `allow ${type} my_device:${class} { perm_set };`
+ 为这个设备设置安全上下文
    `/dev/my_device   u:object_r:my_type:s0`

这样就可以增加一个原本不存在的设备类型了。

