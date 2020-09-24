---
title: GitHub Page 个人博客配置记录
tags:
---

###内容目录

- 使用hexo搭建自己的Github Page博客
- 设置自定义域名，并添加https保护

### 1. 使用hexo搭建Github Page 博客

这部分工作主要参考的是zjufangzh的博客，链接地址为https://blog.csdn.net/sinat_37781304/article/details/82729029

- 首先下载hexo

  hexo官方网站https://hexo.io/zh-cn/

  ~~~sh
  npm install hexo-cli -g
  # Linux npm 安装（如果没有）
  sudo apt-get install nodejs
  sudo apt-get install npm
  ~~~

  在合适的目录开始创建自己的博客

  ~~~sh
  hexo init blog  # 初始化名字为blog的博客
  cd blog
  npm install  
  ~~~

  下载完成之后的目录

  ~~~conf
  node_modules/  依赖包
  scaffolds/  生成文章的模板
  source/  博客内容，主要为md文件
  themes/  博客主题
  public/  博客的发布页面
  _config.yml  博客网站的配置文件
  ~~~

  运行

  ~~~sh
  hexo clean  # 清理之前的发布内容
  hexo generate  # 生成新的发布页面，命令可简写为hexo g
  hexo server  # 部署到本地localhost:4000，命令可简写为hexo s 
  ~~~

  浏览器打开http://localhost:4000 即可看到效果

- 博客部署到Github Page上

  登录github，创建一个新的repository，名字为 `username.github.io`，例如我的github账户名为snowroll，所以repository的名字为`snowroll.github.io`

  

  





有兴趣的同学可以参考他的博客，我这里不再赘述。主要讲几点，我在按他的博客操作下遇到的问题以及解决办法。

- 配置github的ssh key的时候，需要将本机上`id_rsa.pub`文件中的内容粘贴到GitHub的setting中

  命令行方法实现文件内容复制到剪切板，Mac系统

  ~~~sh
  # 打开id_rsa.pub所在目录
  pbcopy < id_rsa.pub
  ~~~

- 主题配置

  使用了https://hexo.io/themes/ 下的Yilia-plus主题，个人比较喜欢。项目地址https://github.com/JoeyBling/hexo-theme-yilia-plus ，这个项目的作者还添加很多有意思的东西，比如常见博客下的动态人物live2d。有兴趣可以按他的github要求配置

- yilia-plus的gitment评论系统存在问题

  暂时没有修复，所以暂时禁止了评论功能

- 配置完成之后，更新完文章，如何推送到自己的博客上

  ~~~sh
  hexo clean  # 清除之前的public文件
  hexo d -g  # 重新生成generate public文件夹，并部署deploy到网站
  hexo s -g  # 这个命令用于本地测试，开启本地服务器server localhost:4000 可以在本地预览效果
  ~~~

  



### 2.  设置自定义域名，添加https保护

在创建的snowroll.github.io这个仓库的setting中**GitHub Pages**中设置

在阿里云上购买一个域名

在阿里云上购买免费的证书

