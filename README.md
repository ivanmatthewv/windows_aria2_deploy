# windows 部署配置 aria2

`config.ps1` 文件为配置内容, 按需修改

`$GITHUB_PROXY` 需要修改为实时可用的代理服务或置为空字符串以不使用代理

``` pwsh
git clone --depth 1 https://github.com/67906980725/windows_aria2_deploy.git
Push-Location .\windows_aria2_deploy
powershell.exe -ExecutionPolicy Bypass -File aria2.ps1
```
