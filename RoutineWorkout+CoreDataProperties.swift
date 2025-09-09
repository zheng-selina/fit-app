// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import Foundation
import CoreData


extension RoutineWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineWorkout> {
        return NSFetchRequest<RoutineWorkout>(entityName: "RoutineWorkout")
    }

    @NSManaged public var dayOfWeekR: String?
    @NSManaged public var workoutDescriptionR: String?
    @NSManaged public var workoutTypeR: String?

}

extension RoutineWorkout : Identifiable {

}
