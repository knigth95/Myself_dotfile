# Myself_dotfile

Linux 下的配置文件

## 支持的配置

- nvim（使用 LazyVim）
- vim（无插件）
- zsh（使用 zim）
- tmux（无插件）
- ranger

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


