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
        let transform = TransformOf<Int, NSNumber>(fromJSON: { $0?.intValue }, toJSON: { $0.map { NSNumber(value: $0) } })
        id <- (map["id"], transform)
        iid <- (map["iid"], transform)
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