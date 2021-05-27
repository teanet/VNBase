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
		.library(name: "VNBaseWatch", targets: ["VNBaseWatch"]),
	],
	dependencies: [
		.package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
	],
	targets: [
		.target(name: "VNBase", path: "VNBase/Classes"),
		.target(name: "VNBaseWatch",  path: "VNBase/Watch"),
	],
	swiftLanguageVersions: [
		.v5
	]
)
