---
title: Spring Boot中心跳机制的实现
date: 2020-09-28 20:09:11
tags: heartbeat
categories: spring boot
---

### 内容摘要

- 基于netty的心跳机制实现
- 基于定时器的心跳机制demo实现

<!-- more -->

### 1. 基于netty心跳机制的实现

这部分的主要工作是参考crossoverjie的博客，博客地址为 https://crossoverjie.top/2018/05/24/netty/Netty(1)TCP-Heartbeat/

有兴趣的同学可以移步他的博客进行阅读，我在这里只总结一些我在复现过程中遇到的一些问题及解决方案

- 在`EchoClienthandle`函数中的`SpringBeanFactory`找不到相关包，下面的语句执行出错

  ~~~java
  // 第一行语句出错
  CustomProtocol heartBeat = SpringBeanFactory.getBean("heartBeat", CustomProtocol.class);
  ctx.writeAndFlush(heartBeat).addListener(ChannelFutureListener.CLOSE_ON_FAILURE) ;
  ~~~

  解决：

  查找关于`ChannelHandlerContext.writeAndFlush()`定义，如下

  ~~~java
  public ChannelFuture writeAndFlush(Object msg) {
          return this.writeAndFlush(msg, this.newPromise());
  }
  ~~~

  知`heartBeat`应为一个对象，所以考虑直接`new`，修改如下

  ~~~java
   CustomProtocol customProtocol = new CustomProtocol(1234L, "test");
   ctx.writeAndFlush(customProtocol);
  ~~~

  测试可以使用，具体内容可以自行修改

- 关于编解码的使用

  crossoverjie的博客提供自定义的编解码器，这个可以根据个人需求进行修改

  无论是客户端的`EchoClientHandle`还是服务器端的`HeartBeatSimpleHandle`都继承自`SimpleChannelInboundHandler<I>`抽象类，可以对不同的数据类型做处理，官方文档https://netty.io/4.0/api/io/netty/channel/SimpleChannelInboundHandler.html

  对比博客中的定义及对应的编解码方法

  - 服务器端

  ~~~java
  public class HeartBeatSimpleHandle extends SimpleChannelInboundHandler<CustomProtocol> {
      //...  略去不重要的内容
      // 服务器端使用ByteBuf进行内容发送
      private static final ByteBuf HEART_BEAT =  Unpooled.unreleasableBuffer(Unpooled.copiedBuffer(new CustomProtocol(123456L,"pong").toString(),CharsetUtil.UTF_8));  
      
    	//...
      @Override
      public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
          //...
          // 这里向客户端发送ByteBuf类型的数据，所以客户端必须解析ByteBuf
         	ctx.writeAndFlush(HEART_BEAT).addListener(ChannelFutureListener.CLOSE_ON_FAILURE) ;
    
          }
  super.userEventTriggered(ctx, evt);
      }
  
      @Override
      protected void channelRead0(ChannelHandlerContext ctx, CustomProtocol customProtocol) throws Exception {
        	// 定义了处理CustomProtocol，复现channelRead0
          LOGGER.info("收到customProtocol={}", customProtocol);
          // ... 
      }
  }
  ~~~

  ~~~java
  // 这段代码应该是在客户端，因为客户端收到的是ByteBuf的内容，所以需要解码为CustomProtocol
  public class HeartbeatDecoder extends ByteToMessageDecoder {
      @Override
      protected void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out) throws Exception {
          // ...
      }
  }
  ~~~

  同理不再赘述客户端的内容

- netty心跳机制的问题

  netty底层相当于是基于socket连接实现的，所以需要服务器和客户端进行长连接，耦合严重。倘若，甲方不想心跳机制两端的机器保持socket的连接，只是简单的定时传送数据该如何实现？这就要用到我接下来提到的方法

### 2.  基于定时器的心跳机制demo实现

- 代码逻辑

  A 定时请求数据  ==> 发送请求给B的接口 ==> B的接口接收信息，返回对应的信息 ==> A处理返回的信息

  这个过程不需要A、B两者用socket连接，实现了解耦

- 定时

  参考博客： https://blog.csdn.net/u010963948/article/details/52946268

  ~~~java
  public class HeartBeat {
  
      /**
       * description: 定时器的回调函数
       */
      Runnable runnable = new Runnable() {
          @Override
          public void run() {
            System.out.println("hello world!");  // 自定义你需要的操作
          }
      };
      
      /**
       *
       * description: 定时发送心跳， scheduleAtFixedRate param1： 回调函数 param1： 首次执行滞后时间 param1： 间隔时间 param1： 单位时间
       * @throws InterruptedException
       */
      @PostConstruct  // 依赖注入完成之后，方法就要被执行
      public void start() throws InterruptedException {
          ScheduledExecutorService service = Executors.newSingleThreadScheduledExecutor();
          service.scheduleAtFixedRate(runnable, 1, 10, TimeUnit.SECONDS);
      }
  }
  ~~~

  `PostConstruct`这个注释非常重要，注释对应的方法会在程序的依赖加载完成之后执行，这样就可以不用直接写在`main`函数中

  回调函数中的可能需要对JSON数据进行分析，可以直接使用Gson处理，参考博客https://blog.csdn.net/xingfei_work/article/details/76572550





<center>侠客行
</center>

<center>唐·李白

<center>赵客缦胡缨，吴钩霜雪明。
银鞍照白马，飒沓如流星。

<center>十步杀一人，千里不留行。
事了拂衣去，深藏身与名。

<center>闲过信陵饮，脱剑膝前横。将炙啖朱亥，持觞劝侯嬴。

<center>三杯吐然诺，五岳倒为轻。
眼花耳热后，意气素霓生。

<center>救赵挥金槌，邯郸先震惊。
千秋二壮士，烜赫大梁城。

<center>纵死侠骨香，不惭世上英。
谁能书阁下，白首太玄经。

