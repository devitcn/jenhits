/**
 * 集中清理老旧的Build，释放磁盘空间
 * <p>
 * 创建一个pipeline project 将脚本放在 pipeline script 文本框中
 * 
 * @author lxb
 */
import hudson.model.FreeStyleProject
import jenkins.model.Jenkins

import java.text.SimpleDateFormat
def dateBefore = new SimpleDateFormat("yyyy-MM-dd").parse("2018-01-01")
List<FreeStyleProject> jobs = Jenkins.instance.getAllItems(hudson.model.FreeStyleProject.class);
jobs.each { job ->
    job.builds.each { build ->
        if (build.time < dateBefore) {
            try {
                build.delete();
            } catch (Exception e) {
                println build+"删除异常："+e.getMessage();
            }
        }

    }
}