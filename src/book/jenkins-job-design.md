# Jenkins JOB 配置常见问题

##build脚本要放在源码中

整体的build过程，不论是ant，maven，还是shell，Jenkinsfile都应该放在源码管理里面。

保证build知识可以跟随源代码传递。

经常遇到的的情况是代理里面只有ant，maven的脚本，而又在jenkins里面配置了一个繁冗的shell脚本来搭配运作。这种情况的shell脚本也要作为build script一部分放在SCM里面。

##一切build过程要放在build脚本中

典型的build要有clean过程和compile、package过程。这三个步骤要全部放在build脚本里面。jenkins里面只配置和jenkins相关的操作。

看一个例子：

    pwd
    #打包
    ls -lhtr
    java -version
    rm -f /home/user1/.jenkins/workspace/hjzx/HJZXIT/war/*.war
    ant
    #上传
    scp war/*.war weblogic@10.197.20.8:/weblogic/wls/flex/app/autoDeploy/
    #部署
    ssh weblogic@10.197.20.8 /weblogic/wls/flex/scripts/autoDeploy.sh

在这个例子里面，`rm`是一个clean操作，理应放在ant里面写好，而不是在jenkins里面特别定制。

好的例子：

    #打包
    ant
    #上传
    scp war/*.war weblogic@10.197.20.8:/weblogic/wls/flex/app/autoDeploy/
    #部署
    ssh weblogic@10.197.20.8 /weblogic/wls/flex/scripts/autoDeploy.sh


##清理

##Build

###避免在包中夹带隐藏文件夹

artifact是文件夹的时候容易忘记在复制前清理隐藏文件夹，例如：`.svn`,`.DS_Store`。这些很容易造成存储空间浪费，延长传输时间，意外行为。解决的办法是在`build脚本`中复制文件指令中忽略掉这些文件。

