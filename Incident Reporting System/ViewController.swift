import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var fullName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User(first: "John", last: "Hancock")
        fullName.text = user.fullName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

