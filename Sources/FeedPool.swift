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
        if map.JSON["id"] == nil {
            return nil
        }
    }

    mutating func mapping(map: Map) {
        let transform = TransformOf<Int, Any>(fromJSON: { $0 as? Int }, toJSON: { $0.map { $0 } })
        id <- (map["id"], transform)
        iid <- (map["iid"], transform)
        title <- map["title"]
        assigneeId <- (map["assignee_id"], transform)
        state <- map["state"]
        authorId <- (map["author_id"], transform)
        authorName <- map["author_name"]
        webUrl <- map["web_url"]
    }
}

class FeedPool {
    var issues: [Issue] = []
}