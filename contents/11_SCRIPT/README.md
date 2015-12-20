## avcparser

**avcparser** 是一个用来分析SEAndroid 权限拒绝日志的自动化脚本，可以较好的处理
下列不容易进行人工处理的情况：

1. 大量的slog 中定位权限拒绝日志，包括对成GiB 的log 文件的操作
* 过滤本质上重复的权限拒绝日志
* 对所有的权限拒绝日志给出一个解决策略

项目托管于[Github][ID_SCIRPT_REPO]，你可以像下面一样获得`avcparser` 指令：

```shell
git clone https://github.com/Arondight/avcparser.git avcparser
cd avcparser
perl Makefile.PL
make
sudo make install
```

使用方法请查看项目的[README.md][ID_SCIRPT_REPO_README] 或者运行指令：

```shell
man 1 avcparser
```

如果脚本对某些权限拒绝log 无法进行正确的处理，
请提交[Issues][ID_SCIPRT_REPO_ISSUES] 并贴出相应的Case。

[ID_SCIRPT_REPO]: https://github.com/Arondight/avcparser "点此访问avcparser 项目"
[ID_SCIRPT_REPO_README]: https://github.com/Arondight/avcparser/blob/master/README.md "点此阅读README.md"
[ID_SCIPRT_REPO_ISSUES]: https://github.com/Arondight/avcparser/issues "点此为avcparser 提交Issues"

