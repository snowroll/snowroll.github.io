个人博客

可以使用run.sh来运行部署

run.sh运行方法
~~~sh
# 给sh脚本运行权限
chmod a+x run.sh
# 更新索引条目 npm i hexo-generator-json-content --save，清理之前的文件 hexo clean 部署在github上 hex d -g
./run.sh  
# 带参数的 -s 更新索引 -c 清理文件 -d [d/s] 部署，参数为d是部署在github上，参数为s时部署在本地端口 -do 添加豆瓣页面
./run.sh -s -c -d s -do

~~~