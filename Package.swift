// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Shiloh Service",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        .iOSApplication(
            name: "Shiloh Service",
            targets: ["AppModule"],
            bundleIdentifier: "com.cyberneel.ShilohService",
            teamIdentifier: "AUC32M9R75",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .leaf),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .landscapeRight,
                .landscapeLeft,
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .copy("text-scroll-8bit.mp3"),
                .copy("cyberneel.png")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)
