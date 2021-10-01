// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "VNBase",
	platforms: [
		.iOS(.v10),
		.watchOS(.v5),
	],
	products: [
		.library(name: "VNBase", targets: ["VNBase", "VNEssential", "VNHandlers"]),
		.library(name: "VNEssential", targets: ["VNEssential"]),
		.library(name: "VNHandlers", targets: ["VNHandlers"]),
	],
	dependencies: [
		.package(url: "https://github.com/teanet/SnapKit", .branch("develop")),
	],
	targets: [
		.target(name: "VNBase", dependencies: [
			"VNEssential",
			"SnapKit",
			"VNHandlers"
		], path: "VNBase/Classes"),
		.target(name: "VNEssential",  path: "VNBase/Essential"),
		.target(name: "VNHandlers",  path: "VNBase/Handlers"),
	],
	swiftLanguageVersions: [
		.v5
	]
)
