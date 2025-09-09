// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/22/23

import Foundation


class FitQuestModel {
    init(){}
    //this is the array that is going to hold the routine
//    var allWorkouts:[String:Workouts]=["Sunday":Workouts(),"Monday":Workouts(),"Tuesday":Workouts(),"Wednesday":Workouts(),"Thursday":Workouts(),"Friday":Workouts(),"Saturday":Workouts()]
    //this is the array that is gonna hold the completed workouts.
    //var workoutDone = Workouts()
    
    
    
    func addWorkout(dayOfTheWeek:String,workoutType:String,workoutDescription:String, date:Date){
        let newWorkout = Workout(workoutType: workoutType, dayOfWeek: dayOfTheWeek, workoutDescription: workoutDescription, date: date)

//        print("this is dayOfTheWeek:", dayOfTheWeek)
//        print("type:", workoutType)
//        switch dayOfTheWeek{
//        case "Sunday":
//            allWorkouts["Sunday"]?.add(workout: newWorkout)
//        case "Monday":
//            allWorkouts["Monday"]?.add(workout: newWorkout)
//        case "Tuesday":
//            allWorkouts["Tuesday"]?.add(workout: newWorkout)
//        case "Wednesday":
//            allWorkouts["Wednesday"]?.add(workout: newWorkout)
//        case "Thursday":
//            allWorkouts["Thursday"]?.add(workout: newWorkout)
//        case "Friday":
//            allWorkouts["Friday"]?.add(workout: newWorkout)
//        case "Saturday":
//            allWorkouts["Saturday"]?.add(workout: newWorkout)
//        default:
//            print("error!!!!")
//        }
        //print(allWorkouts[dayOfTheWeek]?.workouts.count)
        
    }
//    func finishedWorkout(dayOfTheWeek:String,workoutType:String,workoutDescription:String, date:Date){
//        //this is gonna be called in the view controller once the button complete workout is pressed
//        let completedWorkout = Workout(workoutType: workoutType, dayOfWeek: dayOfTheWeek, workoutDescription: workoutDescription, date: date)
//        workoutDone.add(workout: completedWorkout)
//    }
}



class Workout {
    var workoutType:String
    var dayOfWeek:String
    var workoutDescription:String
    var date:Date
    
    init(workoutType: String, dayOfWeek: String, workoutDescription: String, date:Date) {
        self.workoutType = workoutType
        self.dayOfWeek = dayOfWeek
        self.workoutDescription = workoutDescription
        self.date = date
    }
    
}
//class Workouts {
//    var workouts:[Workout] = []
//
//    func add(workout: Workout){
//        workouts.append(workout)
//        workouts = workouts.sorted{ $0.date < $1.date}
//    }
//    func get(index:Int)->Workout{
//        return workouts[index];
//    }
//    func isEmptyW(workouts:Workouts) -> Bool{
//        if workouts.workouts.count==0{
//            return true
//        }
//        return false
//    }
//    func remove(index:Int) {
//        workouts.remove(at: index)
//    }
//
//
//}

