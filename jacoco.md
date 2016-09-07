# Jacoco

Jacoco是一个java测试覆盖率收集工具。

Jacoco分两个模块

agent：加载在JVM中收集覆盖率信息
report：将覆盖率信息转换成html report

http://www.jacoco.org/jacoco/trunk/doc/

## 原理

jacoco的工作类似于aspectj，通过agent参数加载，可以统计到到所有class的运行过程。再和测试用例相结合，就能计算出测试的覆盖率。

jacoco有2个模块：

1 core 需要跟随程序启动，收集覆盖率信息，覆盖率信息会转储成文件(*.exec)
2 report 将覆盖率信息计算成报表

## 使用前提

支持静态织入和动态agent两种方式。通常使用agent方式即可。

采用agent方式运行时，生成表报时使用的class文件和运行测试时使用的class文件必须是同一个JDK编译的。否则会提示不匹配。


## 方式agent

`-javaagent:[yourpath/]jacocoagent.jar=[option1]=[value1],[option2]=[value2]`

注意：路径要写对，

支持的参数： http://www.jacoco.org/jacoco/trunk/doc/agent.html

### 远程模式运行，适用于在中间件服务器中加载

server模式，需要连接到端口上去取exec文件

`-javaagent:jacocoagent.jar=output=tcpserver,address=0.0.0.0,port=6300,includes=com.foo.bar.*`

### 运行一次，适用于在单元测试中使用

`-javaagent:~/jacocoagent.jar=destfile=target/jacoco.exec,append=false`

## 下载exec文件

    mvn org.jacoco:jacoco-maven-plugin:0.7.9:dump -Djacoco.address=10.100.0.1 -Djacoco.port=6300 -Djacoco.reset=true
    
## 在中间件中启用jacoco

### tomcat

tomcat 支持 JAVA_OPTS 环境变量：

    export JAVA_OPTS='-javaagent:/opt/lib/jacocoagent.jar=output=tcpserver,address=0.0.0.0,port=6300'

### Service Wrapper

有的中间件使用了 Java Service Wrapper 启动。wrapper 有一个配置文件叫做：wrapper.conf，在其中添加一行：

    wrapper.java.additional.3=-javaagent:/Users/lxb/git/jenhits/jacoco/jacocoagent.jar=output=tcpserver,address=0.0.0.0,port=6300

additional后面的数字可以按顺序递增编号，不要和已经存在的冲突。

## MAVEN中使用

    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <executions>
        <execution>
          <goals>
            <goal>prepare-agent</goal>
          </goals>
          <configuration>
            <includes>cn.devit.demo.cucumber.biz.*</includes>
          </configuration>
        </execution>
      </executions>
    </plugin>




## 检查配置成功

`ps -A | grep javaagent` 能够看到指定的java进程。

或者

`telnet IP地址 6300`应该能够连接成功

## 下载jacoco.exec

    mvn org.jacoco:jacoco-maven-plugin:0.7.9:dump -Djacoco.address=172.27.18.151 -Djacoco.port=6300 -Djacoco.reset=true

## 出汇总结果

### JENKINS 插件


### JENKINS 生成报表

    mvn org.jacoco:jacoco-maven-plugin:0.7.9:report
      