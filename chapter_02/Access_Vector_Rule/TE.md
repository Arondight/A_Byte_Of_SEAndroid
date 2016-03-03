#### TE 语言

SEAndroid 的访问策略使用了TE 语言，该语言的基本语法如下：

```selinux
rule_name source_type target_type : class perm_set;
策略名 主体 客体 : 类别 权限;
```

一个TE 语句的例子如下：

允许recovery 对wpa_socket 和data_file_type 的dir 类型具有create_dir_perms 等三个权限：

```selinux
allow recovery {wpa_socket data_file_type}:dir {create_dir_perms relabelfrom relabelto};
```

