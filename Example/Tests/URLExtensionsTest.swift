//
//  URLExtensionsTest.swift
//  WQBasicModules_Tests
//
//  Created by iMacHuaSheng on 2019/6/21.
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
        let url = URL(string: "https://www.google.com?alipay_sdk=alipay-sdk-java-3.3.87.ALL&app_id=2534364495039&biz_content=%7B%22body%22%3A%22%E5%95%86%E5%9F%8E%E8%B4%AD%E7%89%A9%22%2C%22out_trade_no%22%3A%22190621191%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E6%B5%8B%E8%AF%95%E4%BA%A7%E5%93%811%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fadmin.fkjs365.com%2Falipay%2FnotifyUrl&sign=QeU%2BhcabMSWjWuvp5juTYGex%2FJAYfs6MbyktfBIOHGB3lyycAU6vFaXe67NRs2eI3xdYQJ3RPLOFnSaIxGmU9gWcxMBUYVvLHyJpNUUBFUHwOvVIL6qHNRqjF4ynGZ2MNZOOgOMi6QJPKmSnLHWfGGRILIVQXagaNnsG1eKc5VctM%2B7tOaeUNAu22Lkm4I8bczh6JyBMhpSB%2Fh98mKklPsIhdMv7Bj9XKKMrgLVr8hQJpEOJFdNenhy%2FskkLRhwI74o4k5r9WqZf2d2zCOYzM9G6CSzOvKBazBEkgC%2F6b1ACtW5WFVK0c2ESPqjcZvcS900Z3Jr4RYwmRkmmk1gT%2Bw%3D%3D&sign_type=RSA2&timestamp=2019-06-21+16%3A31%3A50&version=1.0")!
        guard let parameters = url.queryParameters else {
            XCTAssert(false)
            return
        }
        debugPrint(parameters)
        
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
