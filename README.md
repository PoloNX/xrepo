## zeromake's xmake repo

- 全部为 xmake 编译工具控制的依赖库，不包含 cmake 之类的库。
- 可以进行全静态化编译，xmake 对于动态库并不会把动态库安装到系统上。
- 主要是一些项目的依赖希望静态依赖，但是 xmake 的官方库只支持动态(实际上是偷了个懒直接下了预编译的)。
- 还有就是很多的库是有 cmake 的，但是没发现，然后在项目里都已经写好了 xmake 脚本进行编译了，不能浪费还是找个地方放。

### 推荐构建策略

- `run.autobuild` 运行时自动构建
- `package.install_only` 不寻找系统包通过远端获取

```sh
xmake g --policies=run.autobuild,package.install_only
```
