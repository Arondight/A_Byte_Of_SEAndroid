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

