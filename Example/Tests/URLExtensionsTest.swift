//
//  URLExtensionsTest.swift
//  WQBasicModules_Tests
//
//  Created by WQ on 2019/6/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import WQBasicModules

class URLExtensionsTest: XCTestCase {
    var url = URL(string: "https://www.google.com")!
    let params = ["q": "swifter swift"]
    let queryUrl = URL(string: "https://www.google.com?q=swifter%20swift")!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testQueryParameters() {
        //"https://www.google.com?q=swifter%20swift&steve=jobs&empty"
//        let url = URL(string: " ")!
//        guard let parameters = url.queryParameters else {
//            XCTAssert(false)
//            return
//        }
//        debugPrint(parameters)
//        XCTAssertEqual(parameters.count, 2)
//        XCTAssertEqual(parameters["q"], "swifter swift")
//        XCTAssertEqual(parameters["steve"], "jobs")
//        XCTAssertEqual(parameters["empty"], nil)
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
