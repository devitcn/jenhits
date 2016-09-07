/**
 * 汇总所有job的平均执行时间
 * <p>
 * 纳入汇总的几个条件：
 * - FreeStyleProject
 * - 成功的build
 * - 6个月时间之内
 * - 平均值
 *
 * @author lxb
 */
import hudson.model.FreeStyleProject
import hudson.model.Result
import jenkins.model.Jenkins


def today = new Date();
def _6monthBefore = today - 30*6;
List<FreeStyleProject> jobs = Jenkins.instance.getAllItems(hudson.model.FreeStyleProject.class);
println "job\tmean build seconds"
jobs.each { job ->
    List<Long> milliseconds =  job.builds.findAll({build->
        return build.result == Result.SUCCESS &&
                build.time > _6monthBefore ;
    }).collect({build->
        return build.getDuration()
    })
    if(milliseconds){
        def meanTimeInSeconds = (milliseconds.sum() / milliseconds.size() / 1000)
        println "${job.name}\t${meanTimeInSeconds}"
    }

}
"Finish."