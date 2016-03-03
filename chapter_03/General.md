### 一般性访问拒绝策略

这类错误在slog 上都体现为`avc denided`，一般会出现在`kernel.log`、`main.log` 和`event.log` 中。一个SEAndroid 访问拒绝的log 如下：

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

**注意**：在构造好`allow` 语句后，需要检查其后的`perm_set` 字段，看是否可用`global_macros` 文件中的宏替代，并决定是否替代。

实际情况中，slog 中往往含有大量的访问拒绝log，而且虽然每条都不相同，但是从关键字段上看，有很多log 往往都是重复的，这样很难进行人工排查。在附录中提供了一个自动化处理脚本`avcparser`，可以使用这个脚本进行log 的处理。

