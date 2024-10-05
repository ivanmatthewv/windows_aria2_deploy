# todo https://github.com/oze4/New-PSService
# 失败的尝试
function Verify-Elevated {
  # Get the ID and security principal of the current user account
  $myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $myPrincipal=new-object System.Security.Principal.WindowsPrincipal($myIdentity)
  # Check to see if we are currently running "as Administrator"
  return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (!(Verify-Elevated)) {
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = $myInvocation.MyCommand.Definition;
  $newProcess.Verb = "runas";
  [System.Diagnostics.Process]::Start($newProcess);

  # exit
}

Push-Location $PSScriptRoot
. .\config.ps1

# 创建 aria2 服务
function aria2_service {
  "
@echo off
cd /d ""$install_dir""
start """" ""$install_dir\aria2c.exe""
" | Out-File $install_dir\aria2.bat -Encoding ASCII

  $serviceName = "aria2"
  $displayName = "aria2"
  $binaryPath = "$install_dir\aria2.bat"

  New-Service -Name $serviceName -DisplayName $displayName -BinaryPathName $binaryPath -StartupType Automatic
}

# 创建 cron 服务
function cron_service {
  "
@echo off
cd /d ""$CRON_PATH""
powershell.exe -ExecutionPolicy Bypass -File ""$SCRIPT_PATH\cron.ps1""
" | Out-File $SCRIPT_PATH\cron.bat -Encoding ASCII
  $serviceName = "cron"
  $displayName = "cron"
  $binaryPath = "$SCRIPT_PATH\cron.bat"

  New-Service -Name $serviceName -DisplayName $displayName -BinaryPathName $binaryPath -StartupType Automatic
}

aria2_service
cron_service