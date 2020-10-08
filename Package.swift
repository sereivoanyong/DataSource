// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "DataSource",
  platforms: [
    .iOS(.v10)
  ],
  products: [
    .library(name: "DataSource", targets: ["DataSource"]),
    .library(name: "DTPhotoViewerDataSource", targets: ["DTPhotoViewerDataSource"]),
    .library(name: "FSPagerViewDataSource", targets: ["FSPagerViewDataSource"])
  ],
  dependencies: [
    .package(url: "https://github.com/ra1028/DifferenceKit", "1.1.5"..<"2.0.0"),
    .package(url: "https://github.com/tungvoduc/DTPhotoViewerController", "3.1.1"..<"4.0.0"),
    .package(url: "https://github.com/WenchaoD/FSPagerView", .revision("ca03ae6475ff9a3d42ab6ea23878ffa40f3bb5cb"))
  ],
  targets: [
    .target(name: "DataSource", dependencies: ["DifferenceKit"]),
    .target(name: "DTPhotoViewerDataSource", dependencies: ["DifferenceKit", "DTPhotoViewerController"]),
    .target(name: "FSPagerViewDataSource", dependencies: ["DifferenceKit", "FSPagerView"])
  ]
)
