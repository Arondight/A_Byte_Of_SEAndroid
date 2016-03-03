### 安全上下文（Security Context）

Linux 下[coreutils](http://ftp.gnu.org/gnu/coreutils/) 中的一些指令提供了`-Z` 参数，在SELinux 环境中，`-Z` 参数将会打印出对象对应的SELinux 的安全上下文。

主体和客体都有对应的安全上下文，一个主体的例子如下：

```bash
root@scx35l64_sp9838aea_5mod:/ # ps -Z init
LABEL                          USER     PID   PPID  NAME
u:r:init:s0                    root      1     0     /init
```

一个客体的例子如下：

```bash
root@scx35l64_sp9838aea_5mod:/ # ls -Zl /init
-rwxr-x--- root     root              u:object_r:rootfs:s0 init
```

字段的含义如下：

| 名称 | user | role | type | range |
| --- | --- | --- | --- | --- |
| 含义 | 所属用户 | 所属角色 | 类型 | 分级 |
| 示例 | u | r | init | s0 |

其中有一些需要注意的地方：

+ **user**: Android 中只有一个`u`
+ **role**: Android 中主体的对象为`r`， 客体的为`object_r`，没有其他情况
+ **type**：对象的类型
+ **range**: 不同级别的客体需要对应的主体访问，Android 中只有一个`s0`

> 更多信息请参阅官方文档[Security Context][ID_Security_context]章节。

[ID_Security_context]: http://selinuxproject.org/page/Security_context "点此跳转官方Wiki"

