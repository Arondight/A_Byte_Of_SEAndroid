#### `class` 和`perm_set`

`class` 是对象的类别，SEAndroid 中在`external/sepolicy/security_classes` 定义。`perm_set` 是对象拥有的操作，在`external/sepolicy/access_vectors` 定义。

`class` 字段和`perm_set` 的例子如下，例子中定义了一个数据库表的类别（`class`）和对应的操作（`perm_set`）：

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

