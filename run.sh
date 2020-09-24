# 默认直接部署
if [ $# -lt 1 ]  # $# 获取输入个数，选项-lt表示less than
then  
  npm i hexo-generator-json-content --save
  hexo clean        
  hexo d -g
fi

# -s 设置搜索目录 -c clean -d "s" 本地服务 "d" 部署到Gitpage
while [ -n "$1" ]
do
  case "$1" in
    "-s")
      npm i hexo-generator-json-content --save
      ;;
    "-c")
      hexo clean
      ;;
    "-d")
      if [ "$2" == 'd' ]
      then
        hexo d -g
      else
        hexo s -g
      fi
      ;;
  esac
  shift  # 没有用break，所以必须左移参数让while退出
done
