// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import UIKit
import CoreData
import SpriteKit

class BadgesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var unearnedBadges: [Badge]?
    var earnedBadges: [Badge]?
    var streaks:[Streak]?
    var actualStreak:Int = 0
    
    var previousCount = -1
    var count = 0
    
    @IBOutlet weak var badgesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.badgesTableView.delegate = self
        self.badgesTableView.dataSource = self
        self.badgesTableView.rowHeight = 100
        do {
            let request = Badge.fetchRequest() as NSFetchRequest<Badge>
            let numOfBadges = try context.count(for: request)
            if (numOfBadges == 0) {
                initializeBadgesInCoreData()
            }
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchStreak()
    }
    func initializeBadgesInCoreData() {
        let numbers = [1,5,10,20,50,100]
        for n in numbers {
            let badge = Badge(context:self.context)
            badge.setValue(n, forKeyPath: "id")
            badge.setValue("Streak of \(n)", forKey: "title")
            badge.setValue("\(n) day in a row!", forKey: "badgeDescription")
            badge.earned = false
            do {
                try context.save()
            } catch {}
        }
    }
    func fetchStreak() {
        let request = Streak.fetchRequest() as NSFetchRequest<Streak>
        do {
            let streak = try context.fetch(request)
            actualStreak = Int(streak[0].currentStreak)
        } catch {
            print(error)
        }
        fetchEarnedBadges()
    }

    func fetchEarnedBadges() {
        // first check if they have earned any more badges
        do {
            var request = Badge.fetchRequest() as NSFetchRequest<Badge>
            var pred = NSPredicate(format: "earned == %d", false)
            request.predicate = pred
            self.unearnedBadges = try context.fetch(request)
            for badge in self.unearnedBadges! {
                if (actualStreak >= badge.id) {
                    badge.earned = true
                    viewSetUp()
                    dispatchEffect()
                }
            }
            try context.save()
            // now fetch all earned badges
            request = Badge.fetchRequest() as NSFetchRequest<Badge>
            pred = NSPredicate(format: "earned == %d", true)
            request.predicate = pred
            self.earnedBadges = try context.fetch(request)
            self.badgesTableView.reloadData()
            
        } catch {
            print(error)
        }
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earnedBadges!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "badgesCell", for: indexPath) as! BadgesTableViewCell
        
        let badge = self.earnedBadges![indexPath.row]
        cell.title.text = badge.title
        cell.badgeDescription.text = badge.badgeDescription
        let image = UIImage(named: newBadge(index: indexPath.row))
        cell.badgeImage.image = image

        return cell
    }
    
    // Sprite Kit Effects
    
    private let skView = BadgeSKView()
    
    private func viewSetUp(){
        view.addSubview(skView)
        skView.allowsTransparency = true
        skView.translatesAutoresizingMaskIntoConstraints = false

        let top = skView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0)
        let leading = skView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 0)
        let trailing = skView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        let bottom = skView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([top,leading,trailing, bottom])
    }
    private func dispatchEffect(){
        let badgeEffect = BadgeEffect(size: CGSize(width: 1080, height: 1920))
        badgeEffect.scaleMode = .aspectFill
        badgeEffect.backgroundColor = .clear
        
        skView.presentScene(badgeEffect)
    }
    
    func newBadge(index:Int) -> String{
        switch index{
        case 0:
            return "Case 1"
        case 1:
            return "Case 2"
        case 2:
            return "Case 3"
        case 3:
            return "Case 4"
        case 4:
            return "Case 5"
        case 5:
            return "Case 6"
        default:
            return "Case 1"
        }
    }
    
}
