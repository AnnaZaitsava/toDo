
import UIKit

struct TaskResponse: Decodable {
    let todos: [TaskModel]?
    let total: Int
    let skip: Int
    let limit: Int
}

struct TaskModel: Decodable {
    let id: Int
    var todo: String
    var desc: String?
    var completed: Bool
    let userId: Int
    var date: Date? = Date()
}

