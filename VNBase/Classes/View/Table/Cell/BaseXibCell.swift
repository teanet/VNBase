import UIKit

open class BaseXibCell<TViewModel: BaseCellVM> : BaseCell<TViewModel> {

	open override class func nib() -> UINib? {
		let bundle = Bundle.main
		let name = "\(self)"
		let nib = UINib(nibName: name, bundle: bundle)
		return nib
	}
}
