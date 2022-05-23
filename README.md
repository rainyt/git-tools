## Git-tools GIT分批提交资源工具
这是一个简易的批量提交资源的实现，例如有很多大量的资源，超过100MB以上需要分批提交时，会很容易发生与服务器中断导致无法提交资源时进行使用。

## 环境
- Haxe4.2.5

## 安装库
```shell
haxelib git https://github.com/rainyt/git-tools.git
```

## 使用
### 分批提交文件
```shell
haxelib run git-tools commit git文件目录
```