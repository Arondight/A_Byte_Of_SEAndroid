##### 找出可用的客体类型

分别在原生和第三方策略文件中找出`surfaceflinger` 可以操作什么客体的`chr_file` 类型：

```bash
$ grep -rnP 'allow\h+surfaceflinger.+chr_file' $(find external/sepolicy device/sprd -name '*.te')
external/sepolicy/surfaceflinger.te:26:allow surfaceflinger gpu_device:chr_file rw_file_perms;
external/sepolicy/surfaceflinger.te:30:allow surfaceflinger graphics_device:chr_file rw_file_perms;
external/sepolicy/surfaceflinger.te:34:allow surfaceflinger video_device:chr_file rw_file_perms;
external/sepolicy/surfaceflinger.te:58:allow surfaceflinger tee_device:chr_file rw_file_perms;
```

从结果来看，安全上下文的type 可以是`gpu_device`、`graphics_device`、`video_device` 和`tee_device`，这时候需要和对应的owner 沟通确认。

