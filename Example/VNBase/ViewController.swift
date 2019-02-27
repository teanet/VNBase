import UIKit
import VNBase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let tableVC = TableDemoVC(viewModel: TableDemoVM())
		self.dgs_add(vc: UINavigationController(rootViewController: tableVC), view: self.view)
    }

}

