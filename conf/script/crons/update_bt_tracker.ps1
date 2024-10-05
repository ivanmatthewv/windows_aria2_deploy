# 30分执行一次
$seconds = 1800
$cnt = $args[0]

function task() {
  powershell.exe -ExecutionPolicy Bypass -File $APP_PATH\aria2\update_bt_tracker.ps1
}

if (!$cnt -or ($cnt % $seconds) -eq 0) {
  "[$(Get-Date)] $($MyInvocation.MyCommand.Name) begin"
  task
  "[$(Get-Date)] $($MyInvocation.MyCommand.Name) end"
}