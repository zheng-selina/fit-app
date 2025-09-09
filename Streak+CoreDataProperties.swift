// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import Foundation
import CoreData


extension Streak {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Streak> {
        return NSFetchRequest<Streak>(entityName: "Streak")
    }

    @NSManaged public var currentStreak: Int64

}

extension Streak : Identifiable {

}
