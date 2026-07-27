// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name:"apxor_flutter",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "apxor-flutter", targets: ["apxor_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/apxor/ApxorSDK", from: "2.10.44")
    ],
     targets: [
        .target(
            name: "apxor_flutter",
            dependencies: [
                .product(name: "ApxorSDK",            package: "ApxorSDK"),
                .product(name: "APXContextEvaluator",  package: "ApxorSDK"),
                .product(name: "APXRTAPlugin",         package: "ApxorSDK"),
                .product(name: "APXWYSIWYGPlugin",     package: "ApxorSDK"),
                .product(name: "APXSurveyPlugin",      package: "ApxorSDK")
            ],
            cSettings: [.headerSearchPath("include")]
        )
    ]
)

