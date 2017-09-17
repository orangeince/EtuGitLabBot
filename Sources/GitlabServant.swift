import PerfectLib
import SwiftyJSON

class GitlabServant {
    static let shared: GitlabServant = GitlabServant()
    //var feedStore: [Int: FeedPool] = [:]
    var feedPool: FeedPool = FeedPool()

    func didReceived(message: String) {
        guard let jsonDict = (try? message.jsonDecode()) as? [String: Any] else {
            print("json parse failed!!: \(message)")
            return 
        }
        let json = JSON(jsonDict)
        guard let taskType = json["object_kind"].string else {
            print("object_kind 解析失败!")
            return
        }
        switch taskType: {
            case "issue":
                handleIssueTask(data: json)
            case "merge_request":
                break
            case "note":
                break
            default:
                break
        }
    }

    func handleIssueTask(data: JSON) {
        let issueJson = data["object_attributes"]
        guard let id = issueJson["id"].int,
            let iid = issueJson["iid"].int,
            let assigneeId = issue["assignee_id"].int,
            let title = issueJson["title"].string else {
            print("issue data 解析失败")
            return
        }
        let issue = Issue(id: id, iid: iid, title: title, assigneeId: assigneeId)
        print("issue: \(issue)")
        feedPool.issues.append(issue)
    }
}
