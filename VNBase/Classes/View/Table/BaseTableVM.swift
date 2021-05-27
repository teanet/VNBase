import UIKit

open class BaseTableVM: BaseViewControllerVM {

	public let tableVM: BaseTableViewVM

	public init(title: String? = nil, tableVM: BaseTableViewVM) {
		self.tableVM = tableVM
		super.init()
		self.title = title
	}

}
