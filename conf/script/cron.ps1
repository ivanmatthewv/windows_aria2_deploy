# 原子等待时间 10秒
$normal_sleep_time = 10
# 第一次等待时间
$first_sleep_time = $args[0]

function excute_one([String] $f, [int] $cnt) {
  powershell.exe -ExecutionPolicy Bypass -File $f $cnt
}

function taks([int] $cnt) {
  foreach ($f in Get-ChildItem) {
    excute_one $f $cnt
  }
}

function cron {
  Start-Sleep -Seconds $first_sleep_time
  $cnt = $normal_sleep_time
  while ($true) {
    taks $cnt
    Start-Sleep -Seconds $normal_sleep_time
    $cnt += $normal_sleep_time
  }
}

taks
cron