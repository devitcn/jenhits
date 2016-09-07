# 部署和发布

指导原则：

1. 统一过程

统一使用SSH来处理上传和发布

    scp ***.jar user@dev.local:~/opt/app/foo
    ssh user@dev.local /opt/app/foo/tool.sh redeploy
2. 无密码登录

因为JOB需要自动运行，这个过程中无法处理密码登录的场景。

1. 使用公钥登录

2. 将密码保存成Jenkins中的变量，在脚本中引入。

3. 配置入库

将脚本纳入版本管理，只在jenkins处调用一下
将重启和发布的命令放在远端服务器上

## 统一环境差异

### 统一成SSH环境

通常开发、联调的环境都安装的是Linux环境，我们建议都适用SSH和Shell命令来编写上传，部署，发布过程。

Windows系统可以安装Cygwin来仿真shell环境

#### Windows 安装SSH

Windows安装SSH有多种方法，推荐

1：cygwin 可以创建一个仿真的linux shell环境，缺点是不是完全兼容

2：OpenSSH 只有基础的SSH功能，只能执行Window命令

安装文档：https://winscp.net/eng/docs/guide_windows_openssh_server

#### 使用freeSSHD

http://www.freesshd.com/ 相当简单，一路单击下来即可以安装成功。

在freesshd配置界面，Users选项卡，添加administrator，让其能够使用SSH和SFTP

原文： http://techgenix.com/install-SSH-Server-Windows-Server-2008/

#### WIN10安装 Open SSH

1. 开始菜单，Manage optional features，Add a Feature，OpenSSH server。

2. 配置权限

After you log back in, the sshd service will not be started and if you try to start it, Windows will report it does not have the required privileges for the service to start.

The missing privilege that the service needs is Replace a Process Level Token and we have to add it to the NT Service\sshd account. To do that, open the **Local Security Policy** Editor by searching for secpol in the Start Menu and selecting the Local Security Policy result that appears. 

When the Local Security Policy Editor opens, you should expand **Local Policies** and left click on User Rights Assignment. Once you have selected User Rights Assignment, you will see various privileges in the right pane. Scroll down till you see the Replace a process level token privilege and double-click on it. This will open the properties for that privilege and show the accounts or groups that it is currently assigned to.

3. 生成hostkey

    C:\Windows\System32\OpenSSH\ssh-keygen.exe -A

原文：https://www.bleepingcomputer.com/news/microsoft/how-to-install-the-built-in-windows-10-openssh-server/


### Windows 统一使用Powershell

如果你的生产环境全部都是Window，那么建议统一使用PowerShell 来管理部署和发布





## PHP

常用的方法是增量文件复制，Rsync，ftp，xcopy。

##JAVA

JAVA 项目通常需要执行中间件提供的批处理工具来实现重新部署。

### Tomcat

#### 前提条件

[Tomcat 文档](http://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html "Tomcat 文档") 

Tomcat的命令行部署需要通过`manager.war`进行，这个war已经跟随tomcat一起安装。有时为了限制访问已经将之删除，可以从其他安装文件中复制出来。

可以通过限制访问IP来保护manager的安全：

在`tomcat\conf\Catalina\localhost\`里面粘贴`manager.xml`，可以限制只能127.0.0.1访问。

    <?xml version='1.0' encoding='utf-8'?>
    <Context privileged="true" antiResourceLocking="false"
             docBase="${catalina.home}/webapps/manager">
      <Valve className="org.apache.catalina.valves.RemoteAddrValve"
             allow="127\.0\.0\.1" />
    </Context>

或者，可以通过前端代理来保护

####  脚本范例

    p=`printf 'tomcat:s3cret' | base64 -`
    path=/foo
    #url 转义
    war="file:/absolute/path/to/a/webapp.war"
    war="file%3A"$PWD"/"target/app.war
    #first deploy
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/deploy?path=$path&war=$war"
    #redeploy
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/deploy?update=true&path=$path&war=$war"
    #undeploy
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/undeploy?path=$path"
    #list apps
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/list"
    if [[ $R =~ ^OK  ]]; 
    then echo "Deploy Done." ;
    else
        echo $R
        exit(-1) 
    fi

####  脚本范例 tomcat 6

    p=`printf 'tomcat:s3cret' | base64 -`
    path=/foo
    #url 转义
    war="file:/absolute/path/to/a/webapp.war"
    war="file%3A"$PWD"/"target/app.war
    #first deploy
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/deploy?path=$path&war=$war"
    #redeploy
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/deploy?update=true&path=$path&war=$war"
    #undeploy
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/undeploy?path=$path"
    #list apps
    curl -H "Authorization: Basic $p" "http://127.0.0.1:8080/manager/text/list"
    if [[ $R =~ ^OK  ]]; 
    then echo "Deploy Done." ;
    else
        echo $R
        exit(-1) 
    fi

### Glassfish

glassfish直接提供命令行工具来实现程序的部署。

    asadmin start-domain 
    asadmin stop-domain
    asadmin restart-domain
    
    #标题，在GUI中显示的名称
    title=SOME
    #上下文路径前缀
    url="/"
    #包的路径
    warPath="~/app/FOO.war"
    #--target server表示将程序部署到哪个服务器上，如果你是集群的话这里就会不一样，测试环境的话是server自己。
    asadmin redeploy --name $title --target server --contextroot $url --type war $warPath
    asadmin deploy --name $title --target server --contextroot $url --type war $warPath 
    asadmin undeploy $title
    #创建一个属性，相当于运行的时候附加-D
    asadmin create-system-properties spring.profiles.active=production
    asadmin list-system-properties 
    
### Weblogic

. $WLS_HOME/wlserver_10,3/server/bin/setWLSEnv.sh
java weblogic.Deployer -debug -remote -verbose -upload \
-name $1
-source $WLS_HOME/user_projects/domains/cic_domain/server/AdminServer/upload/${1}.war \
-targets AdminServer \
-adminurl t3:localhost:7001 \
-user weblogic -password '********' -redeploy

https://docs.oracle.com/cd/E24329_01/web.1211/e24443/wldeployer.htm#DEPGD318  命令行参考

### WebSphere 

1. 使用命令工具

- 上传文件到远程服务器
- 执行重新部署命令

    wsadmin -host localhost -user admin -password admin
    $AdminApp list
    
    $AdminApp uninstall demo
    
    $AdmiApp list
    
    $AdminApp install /opt/demo.war {-appname demo -contextroot /demo -usedefaultbindings }
    
    $AdminControl invoke $appManager startApplication demo
    
    $AdminConfig save
    
    set appManager [$AdminControl queryNames type=ApplicationManager,*]
    $AdminControl invoke $appManager startApplication demo
    
BAT:
        
    set PATH=%PATH%;C:\IBM\WebSphere\AppServer\bin
    wsadmin -user admin -password admin -c "$AdminApp uninstall demo" -c "$AdminApp install d:/app/demo.war {-appname demo -contextroot /demo -usedefaultbindings }" -c "$AdminConfig save"
    wsadmin -user admin -password admin -c "set appManager [$AdminControl queryNames type=ApplicationManager,*]" -c "$AdminControl invoke $appManager startApplication demo"


3. 使用Jenkins插件



## 附录

### Jenkins机需要跳过Host验证

    vim ~/.ssh/config
    Host *
        StrictHostKeyChecking no
        
### 安装Cygwin

### 全新安装

下载安装器

https://cygwin.com/setup-x86_64.exe

https://cygwin.com/setup-x86_64.exe

安装器可以安装过程下载的包缓存

在包选择界面选择你需要额包：

- openssh
- vim
- curl
- wget

### 复制安装

将缓存和setup-x86.exe 程序一起打包，可以复制到任意机器重复安装过程。


### 配置SSHD

#### 安装服务
    ssh-host-config --debug --yes --cygwin 'binmode ntsec tty' --pwd '!!!@@@***123qweQWE'

  参数的含义：
      
    $ ssh-host-config --help
    usage:  [OPTION]...
    
    This script creates an OpenSSH host configuration.
    
    Options:
      --debug  -d            Enable shell's debug output.
      --yes    -y            Answer all questions with "yes" automatically.
      --no     -n            Answer all questions with "no" automatically.
      --cygwin -c <options>  Use "options" as value for CYGWIN environment var.
      --name   -N <name>     sshd windows service name.
      --port   -p <n>        sshd listens on port n.
      --user   -u <account>  privileged user for service, default 'cyg_server'.
      --pwd    -w <passwd>   Use "pwd" as password for privileged user.
      --privileged           On Windows XP, require privileged user
                             instead of LocalSystem for sshd service.

相关文档：
  
-  https://docs.oracle.com/cd/E25178_01/install.1111/e22624/preinstall_req_cygwin_ssh.htm
-  https://wiki.jenkins.io/display/JENKINS/SSH+slaves+and+Cygwin

注意：启动这个服务的用户需要特别的权限，不能使用简单的用户，你可以让ssh-host-config自己创建这个账号。
如果你非要修改指定账号的权限，例如使用已经存在的账号builder：

    editrights.exe -a SeAssignPrimaryTokenPrivilege -u builder
    editrights.exe -a SeCreateTokenPrivilege -u builder
    editrights.exe -a SeTcbPrivilege -u builder
    editrights.exe -a SeServiceLogonRight -u builder  
#### 启动服务

    cygrunsrv.exe -S sshd  
### 如果需要重新安装

    cygrunsrv --remove ssh
   ssh-host-config .....



