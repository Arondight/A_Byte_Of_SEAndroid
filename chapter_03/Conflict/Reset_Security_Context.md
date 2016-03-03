#### 重设安全上下文

重设安全上下文有两种情况，一种是给主体设置，一种是给客体设置，前面的`/dev/mail0` 即为给客体设置。

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

第一句定义了slog 本身的类型，第二句定义了slog 可执行文件的类型，第三局从init进程转化为slog domain。

可执行文件的安全上下文设置方法同之前：

```selinux
/system/bin/slog      u:object_r:slog_exec:s0
```

这样就为一个主体（进程）设置了安全上下文。

