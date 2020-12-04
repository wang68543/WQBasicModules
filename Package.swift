//
//  Package.swift
//  WQBasicModules
//
//  Created by WQ on 2019/6/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "WQBasicModules",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "WQBasicModules",
            targets: ["WQBasicModules"])
    ],
    targets: [
        .target(
            name: "WQBasicModules",
            path: "Sources/Classes")
    ],
    swiftLanguageVersions: [.v4, .v5]
)
