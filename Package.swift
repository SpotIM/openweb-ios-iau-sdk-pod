// swift-tools-version:5.9
import PackageDescription

let owIAUSDK = "OpenWebIAUSDK"
let kmm = "KmmSpotimStandaloneAd"
let owIAUWrapperTarget = "OpenWebIAUSDKWrapperTarget"

func createProducts() -> [Product] {
    return [
        .library(name: owIAUSDK, targets: [owIAUWrapperTarget])
    ]
}

func createDependencies() -> [Package.Dependency] {
    return [
        .package(
            url: "https://github.com/SpotIM/openweb-ios-common-sdk-pod",
            .upToNextMinor(from: "1.1.1")
        ),
        .package(
            url: "https://github.com/adsbynimbus/nimbus-ios-sdk",
            .upToNextMinor(from: "2.34.0")
        ),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            .upToNextMinor(from: "12.0.0")
        ),
        .package(
            url: "https://github.com/GeoEdgeSDK/AppHarbrSDK",
            .upToNextMinor(from: "1.14.0")
        )
    ]
}

func createTargets() -> [Target] {
    var targets = [Target]()

    // The SPM variant of the OpenWebIAU SDK xcframework.
    // Emits the same `OpenWebIAUSDK` module as the CocoaPods artifact — consumers
    // `import OpenWebIAUSDK` either way; only the artifact file differs.
    let openWebIAUSDK: Target = .binaryTarget(
        name: owIAUSDK,
        path: "OpenWebIAUSDKSPM.xcframework"
    )
    targets.append(openWebIAUSDK)

    // The shared KMM xcframework the SDK depends on at runtime.
    let kmmTarget: Target = .binaryTarget(
        name: kmm,
        path: "KmmSpotimStandaloneAd.xcframework"
    )
    targets.append(kmmTarget)

    // A "wrapper" target that carries all dependencies: binary targets can't
    // declare dependencies, so this regular target is the real product target.
    let wrapperTarget: Target = .target(
        name: owIAUWrapperTarget,
        dependencies: [
            .target(name: owIAUSDK, condition: .when(platforms: [.iOS])),
            .target(name: kmm, condition: .when(platforms: [.iOS])),
            .product(name: "OpenWebCommon", package: "openweb-ios-common-sdk-pod"),
            .product(name: "NimbusKit", package: "nimbus-ios-sdk"),
            .product(name: "NimbusRenderStaticKit", package: "nimbus-ios-sdk"),
            .product(name: "NimbusGAMKit", package: "nimbus-ios-sdk"),
            .product(name: "NimbusAdMobKit", package: "nimbus-ios-sdk"),
            .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            .product(name: "AppHarbrSDK", package: "AppHarbrSDK")
        ],
        path: owIAUWrapperTarget
    )
    targets.append(wrapperTarget)

    return targets
}

let package = Package(
    name: owIAUSDK,
    platforms: [
        .iOS(.v13)
    ],
    products: createProducts(),
    dependencies: createDependencies(),
    targets: createTargets()
)
