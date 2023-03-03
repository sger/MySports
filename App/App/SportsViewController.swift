import UIKit
import AppFeature

class SportsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad")
    }
}

extension SportsViewController: StoryboardCreatable {
    static var storyboard: StoryboardRepresentable {
        Storyboard.main
    }
}
