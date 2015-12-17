## SEAndroid 基础

### 主体和客体（Subjects and Objects）

* 主体：能够引起客体间的信息交换或者改变系统状态的实体（如进程）
* 客体：可被主体使用的资源（如文件、管道、网络接口等）

> 更多信息请参阅官方文档[Subjects][ID_NB_Subjects]
和[Objects][ID_NB_Objects]章节。

[ID_NB_Subjects]: http://selinuxproject.org/page/NB_Subjects "点此跳转官方Wiki"
[ID_NB_Objects]: http://selinuxproject.org/page/NB_Objects "点此跳转官方Wiki"

### 安全上下文（Security Context）

Linux 下[coreutils](http://ftp.gnu.org/gnu/coreutils/) 中的一些指令提供了`-Z`
参数，在SELinux 环境中，`-Z` 参数将会打印出对象对应的SELinux 的安全上下文。

主体和客体都有对应的安全上下文，一个例子如下：

```shell
root@scx35l64_sp9838aea_5mod:/ # ps -Z init
LABEL                          USER     PID   PPID  NAME
u:r:init:s0                    root      1     0     /init
```

字段的含义如下：

| 名称 | user | role | type | range |
| --- | --- | --- | --- | --- |
| 含义 | 所属用户 | 所属角色 | 类型 | 分级 |
| 示例 | u | r | init | s0 |

其中有一些需要注意的地方：

1. **user**: Android 中只有一个`u`
+ **role**: Android 中主体的对象为`r`， 客体的为`object_r`，没有其他情况
+ **range**: 不同级别的客体需要对应的主体访问，Android 中只有一个`s0`

> 更多信息请参阅官方文档[Security Context][ID_Security_context]章节。

[ID_Security_context]: http://selinuxproject.org/page/Security_context "点此跳转官方Wiki"

### 访问规则（Access Vector Rule）

```
rule_name source_type target_type : class perm_set;
规则名 主体 客体 : 类别 权限;
```

| rule_name | 作用 |
| --- | --- |
| allow | 允许主体对客体某类型具有某权限 |
| neverallow | 类似allow，但作用为禁止 |
| auditallow | 如果规则被allow 允许，事件发生时强制记录事件 |
| dontaudit | 如果规则被neverallow 禁止，事件发生时强制**不**记录事件 |

例子：

```
# 允许recovery 对vfat 的dir 类型具有create_dir_perms 权限
allow recovery vfat:dir create_dir_perms;

# 允许recovery 对wpa_socket 和data_file_type 的dir 类型具有create_dir_perms 等三个权限
allow recovery {wpa_socket data_file_type}:dir {create_dir_perms relabelfrom relabelto};
```

> 更多信息请参阅官方文档[Access Vector Rules][ID_AVCRules]章节。

[ID_AVCRules]: http://selinuxproject.org/page/AVCRules "点此跳转官方Wiki"

### 相关文件

Android 源码目录中和SELinux 相关的文件如下：

#### 原生部分

1. `external/sepolicy/access_vectors`
    * 定义了客体和对应的动作
    * 所有客体：`grep -oP '(?<=^class\h)\w+' sepolicy/access_vectors | sort`
    * 动作在每个客体之下单独定义
+ `external/sepolicy/attributes`
    * 定义了属性
    * 所有的属性：`grep -oP '(?<=^attribute\h)\w+' sepolicy/attributes | sort`

#### 共有部分

| 原生 | 第三方（特指展讯） |
| --- | --- |
| external/sepolicy | device/sprd/$BOARD/sepolicy |

1. `*_contexts` 文件
    * 指定标记
    * `find . -type f -name '*_contexts'`
+ `*.te` 文件
    * Android 的type 和访问规则
    * `find . -type f -name '*.te'`

> PS: 优先修改第三方配置

