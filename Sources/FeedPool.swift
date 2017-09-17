import ObjectMapper

struct Issue: Mappable {
    var id: Int!
    var iid: Int!
    var title: String!
    var assigneeId: Int!
    var state: String!
    var authorId: Int!
    var authorName: String?
    var webUrl: String?

    init?(map: Map) {
        guard let _ = map.JSON["id"] as? Int else {
            return nil
        }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        iid <- map["iid"]
        title <- map["title"]
        assigneeId <- map["assignee_id"]
        state <- map["state"]
        authorId <- map["author_id"]
        authorName <- map["author_name"]
        webUrl <- map["web_url"]
    }
}

class FeedPool {
    var issues: [Issue] = []
}