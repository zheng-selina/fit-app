// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import Foundation
import CoreData


extension Badge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Badge> {
        return NSFetchRequest<Badge>(entityName: "Badge")
    }

    @NSManaged public var id: Int32
    @NSManaged public var earned: Bool
    @NSManaged public var title: String?
    @NSManaged public var badgeDescription: String?

}

extension Badge : Identifiable {

}
