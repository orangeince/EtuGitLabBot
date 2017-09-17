import PerfectLib

typealias Dict = [String: Any]

class GitlabServant {
    static let shared: GitlabServant = GitlabServant()
    var feedStore: [Int: FeedPool] = [:]

    func didReceived(message: String) {
        guard let jsonDict = (try? message.jsonDecode()) as? [String: Any] else {
            print("json parse failed!!: \(message)")
            return 
        }
        guard let taskType = jsonDict["object_kind"] as? String else {
            print("object_kind 解析失败!")
            return
        }
        switch taskType {
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
        guard var issueJson = data["object_attributes"] as? [String: Any] else {
            print("object_attributed 解析失败")
            return
        }
        if let user = data["user"] as? Dict {
            issueJson["author_name"] = user["name"] as? String
        }
        if let project = data["project"] as? Dict, 
            let projectUrl = project["web_url"] as? String,
            let issueId = issueJson["iid"] as? Int {
            issueJson["web_url"] = projectUrl + "/issues/\(issueId)"
        }

        guard let issue = Issue(JSON: issueJson) else {
            print("issue data 解析失败, object_attrs:\(issueJson)")
            return
        }

        guard let pool = feedStore[issue.assigneeId] else {
            print("has not found the subscriber of the issue: \(issue)")
            return 
        }

        pool.issues.append(issue)
    }
    
    func activate(subscriber id: Int, filterLabel: String?) {
        feedStore[id] = FeedPool()
    }

    func getFeedFor(subscriber id: Int) -> String {
        guard let pool = feedStore[id] else {
            return "{}"
        }
        print(pool.issues)
        guard !pool.issues.isEmpty else {
            return "{}"
        }
        let jsonStrs = pool.issues.flatMap{ $0.toJSONString(prettyPrint: true) }
        pool.issues.removeAll()
        return "{[" + jsonStrs.joined(separator: ",") + "]}"
    }
}
