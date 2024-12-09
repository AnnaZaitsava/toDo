import Foundation

enum LocalizedData {
    
    static let tasks = String(localized: "Tasks")
    static let search = String(localized: "Search")
    static let back = String(localized: "Back")
    static let error = String(localized: "Error")
    static let title = String(localized: "TaskTitle")
    static let description = String(localized: "Desc")
    static let ok = "OK"
    
    static let editAction = String(localized: "Edit")
    static let shareAction = String(localized: "Share")
    static let deleteAction = String(localized: "Delete")
}

struct K {
    
    static let urlAPI = "https://dummyjson.com/todos"
    
    static let invalidURL = "Invalid URL"
    static let noData = "No data received"
    static let decodingError = "Failed to decode data:"
    static let networkError = "Network error:"
    static let serverError = "Failed to download image from server"
    
    static let dateFormat = "dd/MM/yyyy"
    
    static let searchField = "searchField"
    static let taskCell = "TaskCell"
    static let taskEntity = "TaskEntity"
    
}
