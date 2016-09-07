#!/bin/bash
#
# 将本地文件批量导入到nexus库中
# nexus支持curl上传
# 使用方法:
# chmod +x wput.sh
# wput.sh path/to/p2 http://localhost:8081/repository/raw1
#
username=admin
password=admin123
remote=$2 #完整的url


LEN=${#1}
for D in `find ${1} -type f -not -path '*/\.*'`
do
    path=${D:$LEN}
    curl -v -u "$username:$password" --upload-file $D $remote$path
done

#参考文档：https://support.sonatype.com/hc/en-us/articles/213465818-How-can-I-programmatically-upload-an-artifact-into-Nexus-2-
#另外一个特性：可以支持zip 解压保存 在url后面附加/content-compressed
#参考文档二：https://github.com/sonatype-nexus-community/nexus-repository-import-scripts/blob/master/mavenimport.sh