# github 代理服务器
if (!$GITHUB_PROXY) { $GITHUB_PROXY = "https://cors.isteed.cc/" }
# 个人 app 根路径
$APP_PATH = "${home}\.local\app"
# aria2 配置路径
$dir_name = "aria2"
$install_dir = "${APP_PATH}\$dir_name"
# aria ng 安装路径
$aria_ng_dir = "${APP_PATH}\aria_ng"
# aria2 版本
$ver = "1.36.0"
# aria ng 版本
$ng_ver = "1.3.6" 
# 个人脚本文件根路径
$SCRIPT_PATH = "${home}\.local\script"
# 个人定时任务路径
$CRON_PATH = "${SCRIPT_PATH}\crons"
# 安装时临时文件下载路径
$DOWN_PATH = "${home}\Downloads"

# 系统自启项目录
$AUTO_START_PATH = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

function mkdir($path) {
  New-Item $path -ItemType Directory -Force -ErrorAction SilentlyContinue
}
mkdir $aria_ng_dir
mkdir $CRON_PATH
