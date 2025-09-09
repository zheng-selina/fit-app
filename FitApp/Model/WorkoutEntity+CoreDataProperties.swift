// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var workoutType: String?
    @NSManaged public var workoutDescription: String?
    @NSManaged public var dayOfWeek: String?

}

extension WorkoutEntity : Identifiable {

}
