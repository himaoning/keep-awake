# Keep Awake — 防止电脑自动睡眠

让电脑在合盖、熄屏后持续运行，适用于下载、挂机、远程访问等场景。

## 支持系统

| 系统 | 状态 | 原理 |
|------|------|------|
| macOS | ✅ 支持 | `caffeinate` 命令 |
| Windows | ✅ 支持 | `powercfg` 电源管理 |

## 快速开始

### macOS

```bash
# 一键设置（开机自动启动 + 合盖不睡眠）
curl -fsSL https://raw.githubusercontent.com/himaoning/keep-awake/main/scripts/setup-mac.sh | bash
```

**管理命令：**
```bash
pgrep caffeinate          # 查看是否在运行
killall caffeinate        # 临时停止
launchctl unload ~/Library/LaunchAgents/com.keepawake.plist  # 禁用开机启动
```

**⚠️ macOS 限制：**
- 合盖不睡眠仅在有电源连接时有效
- 使用电池时，合盖仍会进入睡眠（保护机制，防止电量耗尽）

---

### Windows

**PowerShell（管理员权限）：**
```powershell
# 右键点击 PowerShell，选择"以管理员身份运行"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/himaoning/keep-awake/main/scripts/setup-win.ps1 -OutFile setup-win.ps1
.\setup-win.ps1
```

**恢复默认：**
```powershell
powercfg /change standby-timeout-ac 30   # 恢复30分钟睡眠
powercfg /change hibernate-timeout-ac 60 # 恢复60分钟休眠
```

**⚠️ Windows 限制：**
- 需要管理员权限（修改电源设置）
- 使用电池时仍会按电池设置进入睡眠

---

## 功能对比

| 功能 | macOS | Windows |
|------|-------|---------|
| 开机自动启动 | ✅ LaunchAgent | ✅ 计划任务 |
| 合盖不睡眠 | ✅（需电源） | ✅（需电源） |
| 熄屏不停止 | ✅ | ✅ |
| 无需管理员 | ✅ | ❌ |

---

## 常见问题

**Q: 为什么电池模式下合盖还会睡眠？**
> 这是操作系统的保护机制，防止电量耗尽。macOS/Windows 在电池模式下都会强制睡眠。

**Q: 会影响电脑寿命吗？**
> 长期合盖运行可能导致散热不佳，建议保持通风或使用散热支架。

---

## License

MIT License

---

**Made with 🦞**
