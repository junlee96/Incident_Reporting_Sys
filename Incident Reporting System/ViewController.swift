import UIKit

class ViewController: UIViewController {
//Login page
    

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UIStackView!

    @IBAction func loginBtn(sender: AnyObject) {
    }
    
    @IBAction func resetBtn(sender: AnyObject) {
    }
    
    @IBAction func registerBtn(sender: AnyObject) {
    }
    

//Home page

    
    
//Test page
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

