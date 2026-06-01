#!/bin/bash
# macOS 防睡眠设置脚本
# 设置后，合盖、熄屏都不会让电脑停止运行

set -e

PLIST_FILE="$HOME/Library/LaunchAgents/com.keepawake.plist"

echo "🦞 macOS 防睡眠设置"
echo "================================"

# 创建 LaunchAgent 目录
mkdir -p ~/Library/LaunchAgents

# 创建 plist 文件
cat > "$PLIST_FILE" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.keepawake</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/caffeinate</string>
        <string>-s</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# 加载配置
launchctl load "$PLIST_FILE"

echo ""
echo "✅ 设置完成！"
echo ""
echo "效果："
echo "  • 开机自动启动防睡眠"
echo "  • 合盖不睡眠（需连接电源）"
echo "  • 熄屏也继续运行"
echo ""
echo "管理命令："
echo "  查看状态: pgrep caffeinate"
echo "  临时停止: killall caffeinate"
echo "  禁用自启: launchctl unload $PLIST_FILE"
echo ""
echo "配置文件: $PLIST_FILE"
echo ""
echo "⚠️ 注意：合盖不睡眠仅在有电源连接时有效"
echo "   使用电池时，合盖仍会进入睡眠（保护机制）"
