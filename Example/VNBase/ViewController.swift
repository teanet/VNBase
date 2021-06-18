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
		let vc = Child()
		self.dgs_add(vc: vc, view: self.view)
	}

	@objc private func tableTap() {
		let vc = TableDemoVC(viewModel: TableDemoVM())
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc private func rotateTap() {
		let vc = LandscapeVC(viewModel: LandscapeVM())
		self.navigationController?.pushViewController(vc, animated: true)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		print("viewWillTransition>>>>>\(type(of: self)) \(self.view.bounds)")
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		print("viewWillLayoutSubviews>>>>>\(type(of: self)) \(self.view.bounds)")
	}


	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		print("viewDidLayoutSubviews>>>>>\(type(of: self)) \(self.view.bounds)")
	}
}

class Child: UIViewController {
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		print("viewWillTransition>>>>>\(type(of: self)) \(self.view.bounds)")
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		print("viewWillLayoutSubviews>>>>>\(type(of: self)) \(self.view.bounds)")
	}


	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		print("viewDidLayoutSubviews>>>>>\(type(of: self)) \(self.view.bounds)")
	}
}
