//
//  Package@swift-5.3.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/4/13.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

// swift-tools-version:5.3
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
            path: "Sources")
    ],
    swiftLanguageVersions: [.v4, .v5]
)
