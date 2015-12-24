## 访问拒绝

### 一般性访问拒绝策略

这类错误在slog 上都体现为`avc denided`，一般会出现在`kernel.log`、`main.log`
和`event.log` 中。一个SEAndroid 访问拒绝的log 如下：

```text
03-10 10:46:19.425 <12>[    5.812542] c2 type=1400 audit(1741574778.830:4): avc: denied { read write } for pid=180 comm="surfaceflinger" name="mali0" dev="tmpfs" ino=1527 scontext=u:r:surfaceflinger:s0 tcontext=u:object_r:device:s0 tclass=chr_file
```

除去一些不必太过关心的字段，值得注意的字段如下：

* **denied**: 表示拒绝了什么操作
* **scontext**：主体（操作发起者）的scontext，第三个字段为type
* **tcontext**：客体（操作对象）的scontext，第三个字段为type
* **tclass**：操作的类别
* **name**：访问的设备，如果和原生策略发生冲突，需要修改它的安全上下文。

将上面的信息整理下来，可以将log 描述为：

| 操作 | 主体type | 客体type | 操作类别 |
| --- | --- | --- | --- |
| read write | surfaceflinger | device | chr_file |

结合上一节TE 语言的语法，为了使上面的操作被允许，需要构造一条`allow` 语句：

```selinux
allow surfaceflinger device:chr_file { read write };
```

实际情况中，slog 中往往含有大量的访问拒绝log，而且虽然每条都不相同，但是从关键
字段上看，有很多log 往往都是重复的，这样很难进行人工排查。
在附录中提供了一个自动化处理脚本`avcparser`，可以使用这个脚本进行log 的处理。

### 与谷歌原生策略冲突的解决方法

#### 原生策略冲突分析

虽然可以添加`allow` 语句来对应访问拒绝的情况，但是这样会引入另外一个问题：

谷歌SEAndroid 原生策略中有大量的`neverallow` 语句，如果加入的`allow` 语句和
这些原生策略冲突，代码将会在编译阶段报错退出。

一个冲突的编译log 如下：

```selinux
libsepol.check_assertion_helper: neverallow on line 299 of external/sepolicy/domain.te (or line 5264 of policy.conf) violated by allow surfaceflinger device:chr_file { read write };
```

log 中最重要的信息就是发生冲突的文件以及行数，根据这两个信息可以在文件
`external/sepolicy/domain.te` 中*299* 行找到如下策略：

```selinux
neverallow { domain -unconfineddomain -ueventd -recovery } device:chr_file { open read write };
```

谷歌原生不允许除了`unconfineddomain`、`ueventd` 和`recovery` 之外的domain 对
`device` 客体的`chr_file` 类型进行`open`、`read` 和`write` 操作。

而`surfaceflinger` 在`external/sepolicy/surfaceflinger.te` 第*2* 行定义：

```selinux
type surfaceflinger, domain;
```

自然会和谷歌原生策略冲突。

#### 原生策略冲突的解决

1. 找出`surfaceflinger` 可以操作什么客体的`chr_file` 类型：

    `grep -rnP 'allow\h+surfaceflinger.+chr_file' external/sepolicy`

+ 根据得到的客体类型修改`name` 字段的客体（这里是`mail0`）的安全上下文：

    从第一步的结果来看，安全上下文的type 可以是`gpu_device`、`graphics_device`、
    `video_device` 和`tee_device`，这时候需要和对应的owner 沟通确认。
    以`gpu_device` 为例，重新为`/dev/mail0` 指定上下文：

    `/dev/mali0   u:object_r:gpu_device:s0`

+ 根据新的上下文重写策略：

    `allow surfaceflinger gpu_device:chr_file { read write };`

一般解决和原生策略的冲突需要对冲突项依次进行以上两步操作。

最后还有一个问题，如何知道`name="mali0"` 对应`/dev/mail0`？

```shell
root@scx35l64_sp9838aea_5mod:/ # find /dev -name 'mail0'
/dev/mail0
```

> 有些设备可能在`/dev` 的子目录之中，必须在手机中仔细确认。

#### 无可用的客体类型

如果第一步找不到可以操作的设备类型，那么就需要自己增加一个可用的类型。

假设这个设备的类型为`my_type`，可以通过如下的方法实现：

1. 添加`type` 语句
    `type   my_type dev_type`
+ 为这个类型增加`allow` 语句
    `allow ${type} my_device:${class} { perm_set };`
+ 为这个设备设置安全上下文
    `/dev/my_device   u:object_r:my_type:s0`

这样就可以增加一个原本不存在的设备类型了。

#### 重设安全上下文

重设安全上下文有两种情况，一种是给主体设置，一种是给客体设置，前面的`/dev/mail0`
即为给客体设置。

给客体设置安全上下文只需要在客体后跟上安全上下文即可。

给主体设置会稍微复杂一些，因为主体（进程）由客体转化而来，所以需要：

1. 设置可执行文件的安全上下文
2. 设置主体的domain

其中domain 的设置以slog 为例如下：

```selinux
type slog, domain;
type slog_exec, exec_type, file_type;
init_daemon_domain(slog)
```

第一句定义了slog 本身的类型，第二句定义了slog 可执行文件的类型，第三局从init
进程转化为slog domain。

可执行文件的安全上下文设置方法同之前：

```selinux
/system/bin/slog      u:object_r:slog_exec:s0
```

这样就为一个主体（进程）设置了安全上下文。

