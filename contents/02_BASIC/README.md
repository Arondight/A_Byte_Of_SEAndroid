## SEAndroid 基础

### 主体和客体（Subjects and Objects）

* 主体：能够引起客体间的信息交换或者改变系统状态的实体（如进程）
* 客体：可被主体使用的资源（如文件、pipe、Socket 等）

> 更多信息请参阅官方文档[Subjects][ID_NB_Subjects]
和[Objects][ID_NB_Objects]章节。

[ID_NB_Subjects]: http://selinuxproject.org/page/NB_Subjects "点此跳转官方Wiki"
[ID_NB_Objects]: http://selinuxproject.org/page/NB_Objects "点此跳转官方Wiki"

### 安全上下文（Security Context）

Linux 下[coreutils](http://ftp.gnu.org/gnu/coreutils/) 中的一些指令提供了`-Z`
参数，在SELinux 环境中，`-Z` 参数将会打印出对象对应的SELinux 的安全上下文。

主体和客体都有对应的安全上下文，一个主体的例子如下：

```shell
root@scx35l64_sp9838aea_5mod:/ # ps -Z init
LABEL                          USER     PID   PPID  NAME
u:r:init:s0                    root      1     0     /init
```

一个客体的例子如下：

```shell
root@scx35l64_sp9838aea_5mod:/ # ls -Zl /init
-rwxr-x--- root     root              u:object_r:rootfs:s0 init
```

字段的含义如下：

| 名称 | user | role | type | range |
| --- | --- | --- | --- | --- |
| 含义 | 所属用户 | 所属角色 | 类型 | 分级 |
| 示例 | u | r | init | s0 |

其中有一些需要注意的地方：

1. **user**: Android 中只有一个`u`
+ **role**: Android 中主体的对象为`r`， 客体的为`object_r`，没有其他情况
+ **type**：对象的类型
+ **range**: 不同级别的客体需要对应的主体访问，Android 中只有一个`s0`

> 更多信息请参阅官方文档[Security Context][ID_Security_context]章节。

[ID_Security_context]: http://selinuxproject.org/page/Security_context "点此跳转官方Wiki"

### 访问策略（Access Vector Rule）

#### TE 语言

SEAndroid 的访问策略使用了TE 语言，该语言的基本语法如下：

```selinux
rule_name source_type target_type : class perm_set;
策略名 主体 客体 : 类别 权限;
```

一个TE 语句的例子如下：

允许recovery 对wpa_socket 和data_file_type 的dir 类型具有create_dir_perms
等三个权限：

```selinux
allow recovery {wpa_socket data_file_type}:dir {create_dir_perms relabelfrom relabelto};
```

#### `rule_name`

| rule_name | 作用 |
| --- | --- |
| allow | 允许主体对客体某类型具有某权限 |
| neverallow | 类似allow，但作用为禁止 |
| auditallow | 如果策略被allow 允许，事件发生时强制记录事件 |
| dontaudit | 如果策略被neverallow 禁止，事件发生时强制**不**记录事件 |

#### `class` 和`perm_set`

`class` 是对象的类别，SEAndroid 中在`external/sepolicy/security_classes` 定义。

`perm_set` 是对象拥有的操作，在`external/sepolicy/access_vectors` 定义。

`class` 字段和`perm_set` 的例子如下，
例子中定义了一个数据库表的类别（`class`）和对应的操作（`perm_set`）：

首先在文件`external/sepolicy/security_classes` 中定义一个数据表类别：

```selinux
class db_table			# userspace
```

然后在文件`external/sepolicy/access_vectors` 中定义一个数据库类型的prefix：

```selinux
common database
{
	create
	drop
	getattr
	setattr
	relabelfrom
	relabelto
}
```

同一个文件中，其后定义了数据表的`perm_set`，继承了之前定义的database prefix：

```selinux
class db_table
inherits database
{
	use		# deprecated
	select
	update
	insert
	delete
	lock
}
```

> 更多信息请参阅官方文档[Access Vector Rules][ID_AVCRules]章节。

[ID_AVCRules]: http://selinuxproject.org/page/AVCRules "点此跳转官方Wiki"

### 相关文件

#### 原生部分

1. `external/sepolicy/security_classes`
    * 定义了`class`
    * 所有类别`grep -oP '(?<=^class\h)\w+' external/sepolicy/security_classes | sort`
+ `external/sepolicy/access_vectors`
    * 定义了`perm_set`，规定了对象和对象的操作
    * 操作在每个对象之下单独定义，可能会有继承关系（见上节）
    * 所有对象：`grep -oP '(?<=^class\h)\w+' external/sepolicy/access_vectors | sort`
+ `external/sepolicy/attributes`
    * 定义了属性（属性不能被用于`allow` 语句中）
    * 所有属性：`grep -oP '(?<=^attribute\h)\w+' external/sepolicy/attributes | sort`

#### 共有部分

| 项目 | 目录 |
| --- | --- |
| 原生 | external/sepolicy |
| 5.X 展讯 | device/sprd/${BOARD}/sepolicy |
| 6.X 展讯 | device/sprd/${BOARD}/common/sepolicy |

1. `*_contexts` 文件
    * 安全上下文
    * `find . -type f -name '*_contexts'`
+ `*.te` 文件
    * 访问策略和对象的类型
    * `find . -type f -name '*.te'`

> PS: 优先修改第三方配置，尽量保持原生不动。

