// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import UIKit
import CoreData

class TableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var workouts: [WorkoutEntity]?
    
    func fetchWorkouts() {
        do {
            let request = WorkoutEntity.fetchRequest() as NSFetchRequest<WorkoutEntity>
            let sort = NSSortDescriptor(key: #keyPath(WorkoutEntity.date), ascending: false)
            request.sortDescriptors = [sort]
            if (try context.count(for:request) > 0) {
                self.workouts = try context.fetch(request)
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 145
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchWorkouts()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let workouts = self.workouts {
            return workouts.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        let workout = self.workouts![indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        cell.dateCompleted.text = workout.dayOfWeek! + ", " + dateFormatter.string(from: workout.date!)
        cell.workoutType.text = workout.workoutType
        cell.workoutDescription.text = workout.workoutDescription
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let workoutToRemove = self.workouts![indexPath.row]
            self.context.delete(workoutToRemove)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            self.fetchWorkouts()
            
        }
        
    }

}
