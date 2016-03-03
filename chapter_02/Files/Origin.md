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
+ `gexternal/sepolicy/lobal_macros`
    * 定义了所有宏，为一些权限集合的别名

