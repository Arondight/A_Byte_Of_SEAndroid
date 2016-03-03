#### 原生策略冲突分析

虽然可以添加`allow` 语句来对应访问拒绝的情况，但是这样会引入另外一个问题：

谷歌SEAndroid 原生策略中有大量的`neverallow` 语句，如果加入的`allow` 语句和这些原生策略冲突，代码将会在编译阶段报错退出。

一个冲突的编译log 如下：

```selinux
libsepol.check_assertion_helper: neverallow on line 299 of external/sepolicy/domain.te (or line 5264 of policy.conf) violated by allow surfaceflinger device:chr_file { read write };
```

log 中最重要的信息就是发生冲突的文件以及行数，根据这两个信息可以在文件`external/sepolicy/domain.te` 中*299* 行找到如下策略：

```selinux
neverallow { domain -unconfineddomain -ueventd -recovery } device:chr_file { open read write };
```

谷歌原生不允许除了`unconfineddomain`、`ueventd` 和`recovery` 之外的domain 对`device` 客体的`chr_file` 类型进行`open`、`read` 和`write` 操作。

而`surfaceflinger` 在`external/sepolicy/surfaceflinger.te` 第*2* 行定义：

```selinux
type surfaceflinger, domain;
```

自然会和谷歌原生策略冲突。

