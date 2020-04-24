import UIKit
import VNBase

class ViewController: UIViewController {

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "Table", style: .plain, target: self, action: #selector(self.tableTap)),
			UIBarButtonItem(title: "Rotate", style: .plain, target: self, action: #selector(self.rotateTap)),
		]
    }

	@objc private func tableTap() {
		let vc = TableDemoVC(viewModel: TableDemoVM())
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc private func rotateTap() {
		let vc = LandscapeVC(viewModel: LandscapeVM())
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
