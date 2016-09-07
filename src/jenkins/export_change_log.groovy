import hudson.model.Run;
import hudson.model.AbstractBuild;
import hudson.scm.ChangeLogSet;

/**
 * place enviroment inject plugin run groovy script filed
 */
//Run currentBuild;
//PrintStream out;
if(currentBuild instanceof AbstractBuild) {
    String changeLogAsText = currentBuild.getChangeSet().collect({ChangeLogSet.Entry iter->
        Date dt = new Date(iter.getTimestamp())
        return iter.getCommitId().substring(0, 6) + " " + dt.format("MM-dd HH:mm") +" "+ iter.author + " " +iter.getMsg();
    }).join("\n");
    return ["changeLog":changeLogAsText]
}else {
    out.println("currentBuild is not instance of AbstractBuild, not changeset filed")
}