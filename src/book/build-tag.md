# Build Tag

build tag用来建立编译好的制品和源码之间的关联。

有了build tag可以知道：

- 制品的版本号
- build服务器
- 关联的发布日志
- 源码库中的提交版本

通常生成build tag需要包含的信息有：

Build Number：build序号
SCM ID：源码库中的ID，SVN是一个整数，GIT是一个字符串
时间：打包的时间
版本号：软件项目内部版本号

## SHELL获取GIT库的版本信息

    branch=`git rev-parse --abbrev-ref HEAD`
    commit=`git rev-parse --verify --short=8 HEAD`
    SNAPSHOT=`date +%Y%m%d.%H%M%S`
    buildTag="$branch-$commit-$SNAPSHOT"
    
## 在JENKINS里面得到GIT版本信息

如果项目SCM是GIT，那么在job配置阶段可以使用一下环境变量：

    GIT_COMMIT=af9cb3e96c7e748bb1c501e9e7a89f252d9c8c86
    GIT_BRANCH=origin/master
    BUILD_NUMBER=6

因此TAG可以写成：

    SNAPSHOT=`date +%Y%m%d.%H%M%S`
    buildTag=$BUILD_NUMBER-${GIT_BRANCH#*/}-${GIT_COMMIT:0:8}-$SNAPSHOT
    
## JENKINS得到SVN版本信息

    SVN_REVISION=1234    

## Jenkins 其他环境变量参考

    NODE_NAME=master
    BUILD_DISPLAY_NAME=#6
    JOB_BASE_NAME=mock-api-dev （不带路径的文件名）
    #The current build ID, identical to BUILD_NUMBER for builds created in 1.597+, but a YYYY-MM-DD_hh-mm-ss timestamp for older builds
    BUILD_ID=6
    #String of "jenkins-${JOB_NAME}-${BUILD_NUMBER}". All forward slashes (/) in the JOB_NAME are replaced with dashes (-). Convenient to put into a resource file, a jar file, etc for easier identification.
    BUILD_TAG=jenkins-mockapi-mock-api-dev-6
    #The current build number, such as "153"
    BUILD_NUMBER=6
    JOB_NAME=mockapi/mock-api-dev

## Pipeline 模式下jenkins可以得到的环境变量

使用pipelie脚本的时候不能直接从git步骤得到commit id ，此外取出代码处在detach模式，不能得到分支信息。只能通过shell脚本来进行。

只有`BRANCH_NAME`环境变量可以使用

    BRANCH_NAME=master

## 环境变量里面的URL

    BUILD_URL=http://localhost:8080/job/kanban/job/branch1/job/%E4%B8%AD%E5%8D%8E%E4%BF%9D%E9%99%A9/3/
    JOB_URL=http://localhost:8080/job/kanban/job/branch1/job/%E4%B8%AD%E5%8D%8E%E4%BF%9D%E9%99%A9/
    RUN_CHANGES_DISPLAY_URL=http://localhost:8080/job/kanban/job/branch1/job/%E4%B8%AD%E5%8D%8E%E4%BF%9D%E9%99%A9/3/display/redirect?page=changes
    RUN_DISPLAY_URL=http://localhost:8080/job/kanban/job/branch1/job/%E4%B8%AD%E5%8D%8E%E4%BF%9D%E9%99%A9/3/display/redirect
    HUDSON_URL=http://localhost:8080/
    JENKINS_URL=http://localhost:8080/
    JOB_DISPLAY_URL=http://localhost:8080/job/kanban/job/branch1/job/%E4%B8%AD%E5%8D%8E%E4%BF%9D%E9%99%A9/display/redirect

    
## 在gradle里面设置build号（Android）

    def pipelineVersionInt = { ->
        def envNumber = System.getenv('BUILD_NUMBER')
        return (properties.BUILD_NUMBER?:(envNumber?:1)) as int;
    }
    
    def pipelineVersionLabel = {->
        def tag = System.getenv('VERSION_NAME')
        return (properties.VERSION_NAME?:(tag?:"1.1"));
    }

    android {
        
    
        defaultConfig {
            applicationId "cn.devit.text_intent"
            minSdkVersion 21
            targetSdkVersion 23
            versionCode pipelineVersionInt()
            versionName pipelineVersionLabel()
    
        }
    
    }    