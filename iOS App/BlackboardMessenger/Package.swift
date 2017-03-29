import PackageDescription

let package = Package(
	name: "BlackboardMessenger",
	dependencies: [
		.Package(url: "https://github.com/OpenKitten/MongoKitten.git", majorVersion: 3)
	]
)
