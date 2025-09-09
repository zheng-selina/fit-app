// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import UIKit
import CoreData
import UserNotifications
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var streaksLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var workoutDescriptionLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    var date = Date()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var routine:[RoutineWorkout]?
    let darkPurple = #colorLiteral(red: 0.2738334537, green: 0.2737188041, blue: 0.6896573305, alpha: 1)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDateLabel()
        fetchWorkouts()
        checkForPermission()
        
        do {
            let request = Streak.fetchRequest() as NSFetchRequest<Streak>
            let numOfStreaks = try context.count(for: request)
            if (numOfStreaks == 0) {
                initializeStreak()
            }
        } catch {
            print(error)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchWorkouts()
        updateStreak()
    }

    @IBOutlet weak var completeWorkoutButton: UIButton!
    
    @IBAction func completeWorkout(_ sender: Any) {
        if (completeWorkoutButton.backgroundColor == darkPurple) {
            let request = Streak.fetchRequest() as NSFetchRequest<Streak>
            do {
                let streak = try context.fetch(request)
                let newStreak = streak[0].currentStreak + 1
                streak[0].currentStreak = newStreak
                streaksLabel.text = "Streak: " + String(newStreak)
                saveContext()
            } catch {
                print(error)
            }
            addCompletedWorkout()
            isThereWorkout()
            
            //SPRITE KIT EFFECTS
            viewSetUp()
            dispatchEffect()
        }
//        else {
//            let alertController = UIAlertController(title: "Action not allowed", message: "You have already completed a workout today, this will not affect your streak", preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
//            alertController.addAction(okAction)
//
//            self.present(alertController, animated: true, completion: nil)
//        }
    }

    func initializeStreak() {
        let streak = Streak(context: self.context)
        streak.currentStreak = 0
        saveContext()
    }
    func fetchWorkouts() {
        do {
            let request = RoutineWorkout.fetchRequest() as NSFetchRequest<RoutineWorkout>
            let pred = NSPredicate(format: "dayOfWeekR == %@", dayOfWeek()!)
            request.predicate = pred
            let numOfResults = try context.count(for: request)
            if (numOfResults > 0) {
                self.routine = try context.fetch(request)
            }
            if (self.routine == nil) {
                completeWorkoutButton.isEnabled = false
                self.workoutLabel.text = "No workouts today"
                self.workoutDescriptionLabel.text = "No workouts today"
                completeWorkoutButton.backgroundColor = UIColor.darkGray
            } else {
                self.workoutLabel.text = routine?[0].workoutTypeR
                self.workoutDescriptionLabel.text = routine?[0].workoutDescriptionR
                let workoutRequest = WorkoutEntity.fetchRequest() as NSFetchRequest<WorkoutEntity>
                let numOfWorkouts = try context.count(for:workoutRequest)
                if (numOfWorkouts > 0) {
                    if (lastWorkout()) {
                        completeWorkoutButton.backgroundColor = UIColor.darkGray
                        completeWorkoutButton.isEnabled = false
                    } 
                } else {
                    completeWorkoutButton.backgroundColor = darkPurple
                    completeWorkoutButton.isEnabled = true
                }
            }
            
            
        } catch {
            print(error)
        }
    }
    func isSameDay(_ workoutDate: Date) -> Bool {
        let order = Calendar.current.compare(Date(), to: workoutDate, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    func isThereWorkout(){
        if (routine == nil) {
            completeWorkoutButton.isEnabled = false
            self.workoutLabel.text = "No workouts today"
            self.workoutDescriptionLabel.text = "No workouts today"
            completeWorkoutButton.backgroundColor = UIColor.darkGray
        } else {
            fetchWorkouts()
//            completeWorkoutButton.isEnabled = true
//            completeWorkoutButton.backgroundColor = darkPurple
//            self.workoutLabel.text = routine?[0].workoutTypeR
//            self.workoutDescriptionLabel.text = routine?[0].workoutDescriptionR
        }
    }

    func lastWorkout() -> Bool {
        let request = WorkoutEntity.fetchRequest() as NSFetchRequest<WorkoutEntity>
        let sort = NSSortDescriptor(key: #keyPath(WorkoutEntity.date), ascending: false)
        request.sortDescriptors = [sort]
        do {
            let allWorkouts = try context.fetch(request)
            return isSameDay(allWorkouts[0].date!)
            
        } catch {
            print(error)
        }
        return false
    }
    
    func updateStreak() {
        let workoutRequest = WorkoutEntity.fetchRequest() as NSFetchRequest<WorkoutEntity>
        let sort = NSSortDescriptor(key: #keyPath(WorkoutEntity.date), ascending: false)
        workoutRequest.sortDescriptors = [sort]
        
        let streakRequest = Streak.fetchRequest() as NSFetchRequest<Streak>
        do {
            let streak = try context.fetch(streakRequest)
            let allWorkouts = try context.fetch(workoutRequest)
            
            if (allWorkouts.count > 0) {
                if ((days(from:allWorkouts[0].date!)) > 1) {
                    streak[0].currentStreak = 0
                    try context.save()
                }
            }
            streaksLabel.text = "Streak: \(String(describing: streak[0].currentStreak))"
        } catch { print(error) }
    }
    
    //HELPER FUNCTIONS FOR DATE
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    func setUpDateLabel (){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let monthDay = dateFormatter.string(from: Date())
        self.weekDayLabel.text = dayOfWeek()! + ", " + monthDay

    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date()).capitalized
    }
    
    //CORE DATA HELPER FUNCTIONS
    func saveContext(){
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    func addCompletedWorkout(){
        let completedWorkout = WorkoutEntity(context: self.context)
        completedWorkout.dayOfWeek = dayOfWeek()
        completedWorkout.workoutType = workoutLabel.text
        completedWorkout.workoutDescription = workoutDescriptionLabel.text
        completedWorkout.date = Date()
        saveContext()
        completeWorkoutButton.backgroundColor = UIColor.darkGray
        completeWorkoutButton.isEnabled = false
    }
    
//NOTIFICATIONS CODE
    func checkForPermission(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings{
            settings in
            
            switch settings.authorizationStatus{
            case .authorized:
                if (self.completeWorkoutButton.isEnabled == true){
                    self.dispatchNotification()
                    self.dispatchNotification2()
                }
            case .denied:
                return
            case .notDetermined:
                center.requestAuthorization(options:[.alert,.sound]){ [self]
                    didAllow, error in
                    if didAllow {
                        if (self.completeWorkoutButton.isEnabled == true){
                            self.dispatchNotification()
                            self.dispatchNotification2()
                        }
                    }
                }
            default:
                return
            }
        }
    }
    
    func dispatchNotification (){
        let identifier = "First Notification of the day"
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Keep your streak going!!"
        content.body = "You haven't worked out today, keep your streak going so you have more badges"
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar:calendar , timeZone: TimeZone.current)
        dateComponents.hour = 12
        dateComponents.minute = 45
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.add(request)
        
    }
    
    func dispatchNotification2 (){
        let identifier = "Second Notification of the day"
        let title = "Keep your streak going!!"
        let body = "You haven't worked out today, keep your streak going so you have more badges"
        let hour = 17
        let minute = 23
        let isDaily = true
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar:calendar , timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.add(request)
        
    }
    
    //SETTINNG VIEW EFFECTS
    let skView = BadgeSKView()
    
    func viewSetUp(){
        view.addSubview(skView)
        skView.allowsTransparency = true
        skView.translatesAutoresizingMaskIntoConstraints = false

        let top = skView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0)
        let leading = skView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 0)
        let trailing = skView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        let bottom = skView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([top,leading,trailing, bottom])
    }
    func dispatchEffect(){
        let badgeEffect = BadgeEffect(size: CGSize(width: 1080, height: 1920))
        badgeEffect.scaleMode = .aspectFill
        badgeEffect.backgroundColor = .clear
        
        skView.presentScene(badgeEffect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {self.removeFromView()}
    }
    func removeFromView(){
        skView.removeFromSuperview()
    }
}


