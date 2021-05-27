// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "VNBase",
	platforms: [
		.iOS(.v10),
		.watchOS(.v5),
	],
	products: [
		.library(name: "VNBase", targets: ["VNBase"]),
		.library(name: "VNEssential", targets: ["VNEssential"]),
	],
	dependencies: [
		.package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
	],
	targets: [
		.target(name: "VNBase", dependencies: ["VNEssential"], path: "VNBase/Classes"),
		.target(name: "VNEssential",  path: "VNBase/Essential"),
	],
	swiftLanguageVersions: [
		.v5
	]
)
