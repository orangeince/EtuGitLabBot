import PerfectLib

class GitlabServant {
    static let shared: GitlabServant = GitlabServant()
    //var feedStore: [Int: FeedPool] = [:]
    var feedPool: FeedPool = FeedPool()

    func didReceived(message: String) {
        guard let jsonDict = (try? message.jsonDecode()) as? [String: Any] else {
            print("json parse failed!!: \(message)")
            return 
        }
        guard let taskType = jsonDict["object_kind"] as? String else {
            print("object_kind 解析失败!")
            return
        }
        switch taskType: {
            case "issue":
                handleIssueTask(data: jsonDict)
            case "merge_request":
                break
            case "note":
                break
            default:
                break
        }
    }

    func handleIssueTask(data: [String: Any]) {
        guard let issueJson = data["object_attributes"] as? [String: Any] else {
            print("object_attributed 解析失败")
            return
        }
        guard let id = issueJson["id"] as? Int,
            let iid = issueJson["iid"] as? Int,
            let assigneeId = issue["assignee_id"] as? Int,
            let title = issueJson["title"] as? String else {
            print("issue data 解析失败")
            return
        }
        let issue = Issue(id: id, iid: iid, title: title, assigneeId: assigneeId)
        print("issue: \(issue)")
        feedPool.issues.append(issue)
    }
}
