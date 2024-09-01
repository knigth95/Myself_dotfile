# Myself_dotfile

Linux 下的配置文件

## 支持的配置

- nvim（使用 LazyVim）
- vim（无插件）
- zsh（使用 zim）
- tmux（无插件）
- ranger
- 新增clash全局扩展脚本配置
**注意**：如果使用 conda，请在 `.zshrc` 中将{/home/knight/}设为合适的值,原有的配置文件会被移到 `backup` 中，如果原配置就是软连接则将其删除

## 安装

1. 全部安装：

```bash
chmod a+x ./install.sh && ./install.sh all
```

2. 只安装 `vim`：

```bash
chmod a+x ./install.sh && ./install.sh vim
```
### clash全局扩展脚本配置
- 在clash-verge中将配置文件导入

### 相关指令
##### tmux
- 水平分割窗口: 先按```ctrl+q```再按```\```
- 垂直分割窗口: 先按```ctrl+q```再按```-```
- 关闭当前窗口: 先按```ctrl+q```再按```x```
- 选择窗口: 先按```ctrl+q```再按方向键

