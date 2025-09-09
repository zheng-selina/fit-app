// Marcelo Nogueira mseroesn@iu.edu
// Selina Zheng selzheng@iu.edu
// FitQuest
// 4/28/23

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var workoutType: UILabel!
    @IBOutlet weak var workoutDescription: UILabel!
    @IBOutlet weak var dateCompleted: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
