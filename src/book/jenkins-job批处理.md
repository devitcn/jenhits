# 批处理操作job配置

如果大量job存在相同配置，只是scm部分不同，可以通过[http 接口]("https://wiki.jenkins-ci.org/display/JENKINS/Remote+access+API") 实现批量操作。

首先，假定有如下环境变量存在，分别指登录jenkins的用户名，用户个人的access token（在个人设置页面可以找到），jenkins url 前缀。我们的实例job在“Demo”文件夹里面，名字为“a”

    USERNAME=""
    TOKEN=""
    JENKINS_URL="http://10.196.152.3:8080"


## 下载job配置文件

在浏览器里面，在job 的首页附加config.xml可以下载到job的配置文件。或者使用wget

    wget --auth-no-challenge --user $USERNAME --password $TOKEN  ${JENKINS_URL}/job/Demo/job/a/config.xml

## 写job配置

首先，服务器已经开启了CSRF保护。需要先获取一个CSRF值用在POST接口中：

    wget -q --auth-no-challenge --user $USERNAME --password $TOKEN --output-document - \
    $JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
    
返回的值类似：`Jenkins-Crumb:9d2bd6e844bb29fd128273243b6a3555` 

    CRUMB="Jenkins-Crumb:9d2bd6e844bb29fd128273243b6a3555"    

将修改好的config.xml直接post到job里面完成编辑

    curl -v -X POST -H $CRUMB --data-binary @config.xml -u "${USERNAME}:${TOKEN}" ${JENKINS_URL}/job/Demo/job/a/config.xml

## 通过接口新建JOB

和写job类似，入口有区别（注意看上一节的CRUMB值如何获取）：

    curl -v -X POST -H $CRUMB -H"Content-Type: application/xml" --data-binary @config.xml -u "${USERNAME}:${TOKEN}" ${JENKINS_URL}"/job/Demo/createItem?name=b"
    
## 注意事项

**API Token** 不是登录密码，是jenkins专用来操作API接口的密码。如何获取？个人登录后，在右上角点击登录名，再在左边的菜单点击`设置`进入个人设置页面，展开`API TOKEN`一栏，可以看到token 值。    

如果是Window用户，

curl也可以换成wget，参考下面的例子：

    wget --auth-no-challenge --user=joe.shmoe --password=secret --header="Content-Type: application/xml"  \
         --post-file=config.xml --no-check-certificate           \
         https://jenkins.company.com/job/myProject/config.xml
         
         
         
