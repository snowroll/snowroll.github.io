---
title: GitHub Page 个人博客配置记录
tags: github page
date: 2020-09-24 17:06:25
updated: 
categories: Github
---

### 内容目录

- 使用hexo搭建自己的Github Page博客
- 设置自定义域名，并添加https保护

<!-- more -->

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

  {% asset_img repository_name.jpg %}

  生成ssh，添加到github中

  打开git bash（如没有，请自行查询下载）

  ~~~sh
  git config --global user.name "yourname"  # yourname为你的github用户名
  git config --global user.email "youremail"  # youremail为你的github对应的邮箱
  ssh-keygen -t rsa -C "youremail"  # -t 指定密钥类型，-C 公钥备注，一般写自己的邮箱 生成ssh，一路回车即可
  ~~~

  找到生成的`.ssh`文件夹，打开

  ~~~conf
  id_rsa  # 私钥
  id_rsa.pub  # 公钥
  known_hosts  # 记录服务器端的Host，IP及rsa文件，作缓存用
  ~~~

  复制`id_rsa`内的内容到剪切板，直接打开复制也可以

  ~~~sh
  pbcopy < ./id_rsa.pub  # mac 系统下的命令行操作
  ~~~

  打开github的个人设置中的SSH and GPG keys，点击New SSH key，将复制的内容粘贴进去即可

  测试是否成功

  ~~~sh
  ssh -T git@github.com
  ~~~

  出现 You've successfully authenticated, but GitHub does not provide shell access. 提示即意味成功

  生成ssh key的参考博客，https://blog.csdn.net/qq_36761831/article/details/88725670

  

  将hexo与GitHub关联，修改`blog/`下的`_config.yml`

  ~~~yml
  deploy:
  	type: git
  	repo: https://github.com/yourgithubname/yourgithubname.github.io.git
  	branch: master
  ~~~

  注意在`:`后要添加空格，github貌似要改master分支为main，到时候可能需要更改配置

  安装deploy-git，以便将博客部署到GitHub

  ~~~sh
  npm install hexo-deployer-git --save
  ~~~

  开始部署，更多命令请参考https://hexo.io/zh-cn/docs/commands

  ~~~sh
  hexo clean
  hexo d -g  # d 部署 -g 部署之前预先生成静态文件
  ~~~

  成功之后，过一会就可以在https://yourname.github.io 看到你的博客

- 更改主题，撰写文章

  可以在https://hexo.io/themes/ 下选择自己喜欢的主题，下载到`themes/`目录下

  {% asset_img themes-folder.jpg %}

  `landscape`是默认主题，`yilia-plus`是我下载添加的主题，项目地址https://github.com/JoeyBling/hexo-theme-yilia-plus 

  更改`blog/`下的`_config.yml`

  ~~~yml
  theme: yilia-plus
  ~~~

  重新部署即可生效，具体关于主题的各项设置，请参考各个主题的github项目说明文档

  

  开始写文章

  在`source/post`下的添加.md文件即可，或者

  ~~~sh
  hexo new paper
  ~~~

  更多详细操作参考https://hexo.io/zh-cn/docs/writing 和 https://blog.csdn.net/sinat_37781304/article/details/82729029

  *Tips:  yilia-plus配置search功能，在博客根目录下执行 `npm i hexo-generator-json-content --save`， 在`_config.yml`中添加相关配置*

### 2.  设置自定义域名，添加https保护

- 设置自定义域名

  在阿里云上购买一个域名，看个人需求，我购买了snowroll.top域名，主要是便宜 hhhhh。阿里云域名购买及解析教程链接https://developer.aliyun.com/article/767435

  上面链接的域名操作的“解析设置”里，添加一条记录

  ~~~conf
  记录类型： CNAME  
  主机记录： @  
  解析线路：默认
  记录值： yourname.github.io
  ~~~

  这条解析记录应该是将你申请的域名解析关联到yourname.github.io，再通过github自己的dns服务器进行解析（个人理解，没有实际抓包看过）

  为了让域名生效，还得在`yourname.github.io`仓库的setting中，设置自定义的Custom domain，示例如下

  {% asset_img custom-domain.jpg %}

  未添加https保护时，图中的Enforce HTTPS无法选中，也只能通过http访问自定义域名

  为了防止自定义域名失效，在`blog`的`source/`下新建`CNAME`文件，里面填上你的自定义域名即可

  ~~~txt
  snowroll.top
  ~~~

  可以重新部署，查看一下自己的域名是否生效（重新部署后，可能需要1-2分钟页面才能更新）

- 添加https保护

  为了给自定义的域名，也添加https保护。我们在阿里云上申请一个免费的证书，教程链接https://developer.aliyun.com/article/715576

  签发完成并进行完相关的设置后，可能需要1-2小时https保护才能生效，所以不用过于着急。

  至此，就可以开始愉快的写博客了。

  

