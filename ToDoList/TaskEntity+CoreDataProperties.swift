import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {}

extension TaskEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: K.taskEntity)
    }
    @NSManaged public var date: Date?
    @NSManaged public var userId: Int64
    @NSManaged public var completed: Bool
    @NSManaged public var desc: String?
    @NSManaged public var todo: String?
    @NSManaged public var id: Int64

}

extension TaskEntity : Identifiable {}
