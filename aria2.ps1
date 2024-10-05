Push-Location $PSScriptRoot
. .\config.ps1

function install {
  # 安装 aria2
  $win64_dir = "aria2-$ver-win-64bit-build1"
  $win64_zip = "$win64_dir.zip"

  $d_name = $win64_dir
  $f_name = $win64_zip

  Invoke-WebRequest ${GITHUB_PROXY}https://github.com/aria2/aria2/releases/download/release-$ver/$f_name -OutFile $DOWN_PATH\$f_name
  Expand-Archive -Force -Path $DOWN_PATH\$f_name -DestinationPath $APP_PATH
  Remove-Item $DOWN_PATH\$f_name -Force
  Rename-Item -Path $APP_PATH\$d_name -NewName $dir_name -Force

  # 初始化配置文件
  Copy-Item -Path .\conf\aria2.session -Destination $install_dir -Force

  Copy-Item -Path .\conf\aria2.conf -Destination $install_dir -Force
  (Get-Content "$install_dir\aria2.conf") | Foreach-Object { $_ -replace '^dir=.*', "dir=$DOWN_PATH"; } | Set-Content "$install_dir\aria2.conf"
}

function auto_start {
  # 创建启动快捷方式
  $l_file = "$install_dir\aria2c.lnk"
  $l = (New-Object -ComObject WScript.Shell).CreateShortcut($l_file)
  $l.WorkingDirectory = $install_dir
  $l.TargetPath = "$install_dir\aria2c.exe"
  $l.Arguments = "--conf-path=aria2.conf"
  $l.Save()

  # 添加到自启动
  Copy-Item -Path $l_file -Destination $AUTO_START_PATH -Force  

  Start-Process -FilePath $install_dir\aria2c.lnk
}

function cron {
  # 定时任务
  Copy-Item -Path .\conf\script\cron.ps1 -Destination $SCRIPT_PATH -Force  

  # 创建启动快捷方式
  $l_file = "$SCRIPT_PATH\cron.lnk"
  $l = (New-Object -ComObject WScript.Shell).CreateShortcut($l_file)
  $l.WorkingDirectory = $CRON_PATH
  $l.TargetPath = "powershell.exe"
  $l.Arguments = "-ExecutionPolicy Bypass -File $SCRIPT_PATH\cron.ps1 10"
  $l.Save()

  # 定时任务自启动
  Copy-Item -Path $l_file -Destination $AUTO_START_PATH -Force
}

function update_bt_tracker {
  # tracker 更新脚本
  Copy-Item -Path .\conf\update_bt_tracker.ps1 -Destination $install_dir -Force

  # 创建执行更新快捷方式
  $l_file = "$install_dir\update_bt_tracker.lnk"
  $l = (New-Object -ComObject WScript.Shell).CreateShortcut($l_file)
  $l.WorkingDirectory = $install_dir
  $l.TargetPath = "powershell.exe"
  $l.Arguments = "-ExecutionPolicy Bypass -File update_bt_tracker.ps1"
  $l.Save()

  # 添加定时任务
  Copy-Item -Path .\conf\script\crons\update_bt_tracker.ps1 -Destination $CRON_PATH -Force
  (Get-Content "$CRON_PATH\update_bt_tracker.ps1") | Foreach-Object { 
    if ($_ -like "*powershell.exe*") {
      "powershell.exe -ExecutionPolicy Bypass -File $install_dir\update_bt_tracker.ps1"
    } else {
      $_
    }
  } | Set-Content "$CRON_PATH\update_bt_tracker.ps1"
  
  # Start-Process -FilePath $install_dir\update_bt_tracker.lnk
  Start-Process -FilePath $SCRIPT_PATH\cron.lnk
}

function install_aria_ng {
  # 下载 aria ng
  # 也可以用浏览器扩展接管 aria2
  # https://microsoftedge.microsoft.com/addons/detail/aria2-explorer/jjfgljkjddpcpfapejfkelkbjbehagbh?hl=zh-CN  

  $ng_f_name = "AriaNg-$ng_ver-AllInOne.zip"
  $url = "https://github.com/mayswind/AriaNg/releases/download/$ng_ver/$ng_f_name"

  Invoke-WebRequest ${GITHUB_PROXY}${url} -OutFile $DOWN_PATH\$ng_f_name
  Expand-Archive -Force -Path $DOWN_PATH\$ng_f_name -DestinationPath $aria_ng_dir
  Remove-Item $DOWN_PATH\$ng_f_name -Force
  Rename-Item -Path $aria_ng_dir\index.html -NewName aria_ng.html -Force

  explorer $aria_ng_dir\aria_ng.html
}

install
auto_start
cron
update_bt_tracker
install_aria_ng