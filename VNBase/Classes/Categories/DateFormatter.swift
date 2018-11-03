internal extension DateFormatter {

	internal static var dMMMM: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "d MMMM"
		return df
	}()

	internal static var dMMMMyyyy: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "d MMMM yyyy"
		return df
	}()

	internal static var MMMM: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "MMMM"
		return df
	}()

	internal static var HHmmddMMyyyy: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "HH:mm dd/MM/yyyy"
		return df
	}()

	static let hmm: DateFormatter = {
		let df = DateFormatter()
		df.formatterBehavior = .behavior10_4
		df.dateFormat = "h:mm"
		return df
	}()

	static let hmmaaddMMyyyy: DateFormatter = {
		let df = DateFormatter()
		df.formatterBehavior = .behavior10_4
		df.dateFormat = "h:mm aa dd/MM/yyyy"
		return df
	}()

	static let documentDateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.formatterBehavior = .behavior10_4
//		2018-05-15T16:27:20.6101843
		df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
		return df
	}()

}