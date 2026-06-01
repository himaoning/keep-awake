# Windows 防睡眠设置脚本
# 设置后，电脑不会自动进入睡眠/休眠状态

param(
    [switch]$Start,
    [switch]$Stop,
    [switch]$Install
)

function Set-KeepAwake {
    # 使用 PowerShell 设置电源选项，防止睡眠
    # 这需要管理员权限
    
    Write-Host "🦞 Windows 防睡眠设置" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Gray
    
    # 检查是否管理员权限
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    
    if (-not $isAdmin) {
        Write-Host "⚠️ 需要管理员权限！请右键点击 PowerShell 选择'以管理员身份运行'" -ForegroundColor Yellow
        return
    }
    
    # 设置电源选项：连接电源时不睡眠
    powercfg /change standby-timeout-ac 0
    powercfg /change hibernate-timeout-ac 0
    
    Write-Host ""
    Write-Host "✅ 设置完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "效果：" -ForegroundColor Cyan
    Write-Host "  • 连接电源时不会自动睡眠"
    Write-Host "  • 不会自动进入休眠"
    Write-Host ""
    Write-Host "管理命令：" -ForegroundColor Gray
    Write-Host "  恢复睡眠: powercfg /change standby-timeout-ac 30"
    Write-Host "  查看当前设置: powercfg /query SCHEME_CURRENT SUB_SLEEP"
    Write-Host ""
    Write-Host "⚠️ 注意：使用电池时仍会按电池设置进入睡眠"
    Write-Host "   需要同时设置电池选项：powercfg /change standby-timeout-dc 0"
}

function Stop-KeepAwake {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    
    if (-not $isAdmin) {
        Write-Host "⚠️ 需要管理员权限！" -ForegroundColor Yellow
        return
    }
    
    # 恢复默认设置（30分钟）
    powercfg /change standby-timeout-ac 30
    powercfg /change hibernate-timeout-ac 60
    
    Write-Host "✅ 已恢复默认睡眠设置" -ForegroundColor Green
}

function Install-KeepAwake {
    # 创建启动任务，开机自动运行
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -Command `"$PSScriptRoot\setup-win.ps1 -Start`"" -WorkingDirectory $PSScriptRoot
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    $taskName = "KeepAwake-AutoStart"
    
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description "开机自动设置防睡眠" -Force | Out-Null
    
    Write-Host "✅ 开机自动启动任务已创建！" -ForegroundColor Green
    Write-Host "任务名: $taskName"
    Write-Host ""
    Write-Host "管理命令：" -ForegroundColor Gray
    Write-Host "  查看任务: Get-ScheduledTask -TaskName $taskName"
    Write-Host "  删除任务: Unregister-ScheduledTask -TaskName $taskName -Confirm:$false"
}

# 主逻辑
if ($Stop) {
    Stop-KeepAwake
} elseif ($Install) {
    Install-KeepAwake
} else {
    Set-KeepAwake
}
