extension FileManager { // ApplicationSettings

	static func documentsDirectory() -> String {
		var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
		return paths[0]
	}

	static func libraryDirectory() -> String {
		var paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [String]
		return paths[0]
	}

	static func cacheDirectoryURL() -> URL {
		let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
		return urls[urls.endIndex - 1]
	}

	static func documentsPath(forFileName fileName: String) -> URL? {
		let documentsPath = FileManager.documentsDirectory()
		return FileManager.filePath(withDirectoryPath: documentsPath, fileName: fileName)
	}

	static func libraryPath(forFileName fileName: String) -> URL? {
		let libraryPath = FileManager.libraryDirectory()
		return FileManager.filePath(withDirectoryPath: libraryPath, fileName: fileName)
	}

}

extension FileManager { // Private

	fileprivate static func filePath(withDirectoryPath directoryPath: String, fileName: String) -> URL? {
		let directoryURL = URL(fileURLWithPath: directoryPath)
		let filePath = directoryURL.appendingPathComponent(fileName)

		return filePath
	}

}
