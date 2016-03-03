##### 设置客体安全上下文

根据得到的客体类型修改`name` 字段的客体（这里是`mail0`）的安全上下文。以`gpu_device` 为例，重新为设备`mail0` 指定上下文：

首先查找这个设备在手机中的路径：

```bash
root@scx35l64_sp9838aea_5mod:/ # find /dev -name 'mail0'
/dev/mail0
```

然后对设置设备文件的安全上下文。

```selinux
/dev/mali0   u:object_r:gpu_device:s0
```

策略应该尽量使用正则合并以做到向后的兼容，例如存在大量形如`/dev/videoN` 的设备，都使用同一个上下文，那么为了今后增加的设备也被现在的规则兼容，应当使用正则表达式指定一系列文件的上下文：

```selinux
/dev/video[0-9]*	u:object_r:video_device:s0
```

> 有些设备文件可能在`/dev` 的子目录之中，必须在手机中仔细确认路径。

