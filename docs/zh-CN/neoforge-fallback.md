# NeoForge 后备指南

只有 Fabric 不合适时才使用 NeoForge。Forge 和 NeoForge 是不同 loader，mods 必须匹配 NeoForge。需要时添加 Geyser/Floodgate，并先测试备份。

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## 安全停止

> 输入 `stop` 并保持窗口打开。关闭前等待 `CLEAN SHUTDOWN COMPLETE`，然后等待 `SAFE TO CLOSE`。如果没有第二条消息，请检查日志和崩溃报告，必要时恢复备份。

<!-- jarock-updater -->


## 更新 Jarock

> 读取 `version.txt`，停止服务器并等待 `SAFE TO CLOSE`；然后运行 `update-jarock.bat`。它会在相同的 beta/稳定频道中寻找更新，请求确认并创建回滚备份。世界、运行时、模组、库和本地设置都会保留；只有依赖缺失或无效时才会修复。

> 完整软件包及其发布的 SHA-512 校验和会在安装前进行验证。

<!-- jarock-auto-update-check -->

## 启动时检查更新

在 parameter-manager.bat 中将 AUTO_UPDATE_CHECK=true，可让 start-server.bat 以只读方式检查 GitHub 发布版本。它会报告兼容的新版本 Jarock，但不会自动安装。请停止服务器，等待 SAFE TO CLOSE，然后运行 update-jarock.bat。默认值为 AUTO_UPDATE_CHECK=false。
