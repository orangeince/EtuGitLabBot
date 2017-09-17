struct Issue {
    var id: Int
    var iid: Int
    var title: String
    var assigneeId: Int
    //var state: String
    //var authorId: Int
    //var authorName: String
    //var webUrl: String
}

class FeedPool {
    var issues: [Issue] = []
}