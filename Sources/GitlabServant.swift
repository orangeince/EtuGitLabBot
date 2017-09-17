import PerfectLib

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
        guard let issueJson = data["object_attributes"] as? [String: Any] else {
            print("object_attributed 解析失败")
            return
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
}
