// swift-tools-version:5.5
import PackageDescription

let owIAUSDK = "OpenWebIAU"
let owIAUWrapperTarget = "OpenWebIAUWrapperTarget"

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owIAUSDK, type: .static, targets: [owIAUWrapperTarget])]

    return products
}

func createDependencies() -> [Package.Dependency] {
    return [
        .package(url: "https://github.com/Aniview/ad-player-sdk-ios-spm", .upToNextMinor(from: "1.13.4")),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package", .upToNextMinor(from: "4.5.0")),
        .package(url: "https://github.com/PubMatic/OpenWrapHandlerDFP-Swift-Package", .upToNextMinor(from: "5.2.0")),
        .package(url: "https://github.com/GeoEdgeSDK/AppHarbrSDK", .upToNextMinor(from: "1.14.0")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", .upToNextMinor(from: "11.7.0")),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-sdk", .upToNextMinor(from: "2.25.3")),
        .package(url: "https://github.com/SpotIM/openweb-ios-common-sdk-pod", .upToNextMinor(from: "1.0.0"))
    ]
}

func createTargets() -> [Target] {
    var targets = [Target]()

    // Adding OpenWebIAUSDK xcframework
    let OpenWebIAUSDK: Target = .binaryTarget(
        name: owIAUSDK,
        path: "OpenWebIAUSDK.xcframework"
    )
    targets.append(OpenWebIAUSDK)

		// Adding KmmSpotimStandaloneAd xcframework
    let KmmSpotimStandaloneAd: Target = .binaryTarget(
        name: "KmmSpotimStandaloneAd",
        path: "KmmSpotimStandaloneAd.xcframework"
    )
    targets.append(KmmSpotimStandaloneAd)

    // Adding a "wrapper" target which all xcframeworks are "dependencies" to this one
    let wrapperTarget: Target = .target(
        name: owIAUWrapperTarget,
        dependencies: [
						// xcframeworks
            .target(name: "OpenWebIAU", condition: .when(platforms: .some([.iOS]))),
						.target(name: "KmmSpotimStandaloneAd", condition: .when(platforms: .some([.iOS]))),

						// dependencies
						.product(name: "AdPlayerSDK", package: "ad-player-sdk-ios-spm"),
        		.product(name: "OpenWrapSDK", package: "OpenWrapSDK-Swift-Package"),
        		.product(name: "OpenWrapHandlerDFP", package: "OpenWrapHandlerDFP-Swift-Package"),
        		.product(name: "AppHarbrSDK", package: "AppHarbrSDK"),
        		.product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
        		.product(name: "NimbusKit", package: "nimbus-ios-sdk"),
        		.product(name: "NimbusRenderStaticKit", package: "nimbus-ios-sdk"),
        		.product(name: "NimbusGAMKit", package: "nimbus-ios-sdk"),
        		.product(name: "OpenWebCommon", package: "openweb-ios-common-sdk-pod")
        ],
        path: owIAUWrapperTarget
    )
    targets.append(wrapperTarget)

    return targets
}

let products = createProducts()
let dependencies = createDependencies()
let targets = createTargets()

let package = Package(
    name: owIAUSDK,
    platforms: [
        .iOS(.v13)
    ],
    products: products,
		dependencies: dependencies,
    targets: targets
)