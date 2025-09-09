// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import UIKit
import CoreData

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var dayOfWeekPicker: UIPickerView!
    @IBOutlet weak var workoutTypePicker: UIPickerView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var routine:[RoutineWorkout]?
    
    var daysOfWeek: [String] = [String]()
    var workoutTypes: [String] = [String]()
    
    var selectedDay = "Sunday"
    var selectedType = "Aerobic"
    
    let date = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayOfWeekPicker.delegate = self
        self.dayOfWeekPicker.dataSource = self
        self.workoutTypePicker.delegate = self
        self.workoutTypePicker.dataSource = self
        daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        workoutTypes = ["Aerobic", "Cardio", "HIIT", "Low Impact", "Strength", "Weightlifting", "Yoga", "Other"]
        
        dayOfWeekPicker.reloadAllComponents()
        workoutTypePicker.reloadAllComponents()
        dayOfWeekPicker.selectRow(0, inComponent: 0, animated: true)
        workoutTypePicker.selectRow(0, inComponent: 0, animated: true)
        
        self.descriptionTextField.delegate = self
    }
    
    func fetchWorkouts(_ selectedDay:String) {
        do {
            let request = RoutineWorkout.fetchRequest() as NSFetchRequest<RoutineWorkout>
            
            let pred = NSPredicate(format: "dayOfWeekR == %@", selectedDay)
            request.predicate = pred
            self.routine = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date()).capitalized
    }
    
    @IBAction func editWorkoutButton(_ sender: Any) {
        fetchWorkouts(selectedDay)
        print(routine!.count)
        if routine?.count != 0{
            let alertController = UIAlertController(title: "You already have a workout for that day", message: "Do you wish to add a workout for that day?", preferredStyle: .alert)

            let yesAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
                routine?[0].workoutDescriptionR = self.descriptionTextField.text
                routine?[0].workoutTypeR = selectedType
                routine?[0].dayOfWeekR = selectedDay
                
                saveContext()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in }

            alertController.addAction(yesAction)
            alertController.addAction(noAction)

            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let workoutToBeAdded = RoutineWorkout(context: self.context)
            workoutToBeAdded.workoutDescriptionR = self.descriptionTextField.text
            workoutToBeAdded.workoutTypeR = selectedType
            workoutToBeAdded.dayOfWeekR = selectedDay
        }
        saveContext()
        self.descriptionTextField.text = ""
    }
    func saveContext(){
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return daysOfWeek.count
        } else {
            return workoutTypes.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return daysOfWeek[row]
        } else {
            return workoutTypes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if (pickerView.tag == 1) {
           selectedDay = daysOfWeek[row]
       } else {
           selectedType = workoutTypes[row]
       }
   }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
