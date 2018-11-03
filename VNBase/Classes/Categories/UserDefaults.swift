internal protocol IUserDefaults: AnyObject {

	var didStartEarly: Bool { get set }
	var isLoggedIn: Bool { get set }
	var useBiometrics: Bool { get set }
	var useBiometricsConfirmed: Bool { get set }

}

extension UserDefaults: IUserDefaults {

	var didStartEarly: Bool {
		get { return self.bool(forKey: "didStartEarly") }
		set { self.set(newValue, forKey: "didStartEarly"); self.synchronize() }
	}

	var useBiometrics: Bool {
		get { return self.bool(forKey: "useBiometrics") }
		set { self.set(newValue, forKey: "useBiometrics"); self.synchronize() }
	}

	var isLoggedIn: Bool {
		get { return self.bool(forKey: "isLoggedIn") }
		set { self.set(newValue, forKey: "isLoggedIn"); self.synchronize() }
	}

	var useBiometricsConfirmed: Bool {
		get { return self.bool(forKey: "useBiometricsConfirmed") }
		set { self.set(newValue, forKey: "useBiometricsConfirmed"); self.synchronize() }
	}
}
