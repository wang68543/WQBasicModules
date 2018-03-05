//
//  WQStringExtensionSpec.swift
//  WQBasicModules_Tests
//
//  Created by hejinyin on 2018/2/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
import WQBasicModules
class WQStringExtensionSpec: QuickSpec {
    
    override func spec() {
        describe(".isPureInt") {
            
            it("test regular Expression is Int ") {
                expect("1235".isPureInt) == true
            }
            
//            it("can read") {
//                expect("number") == "string"
//            }
//
//            it("will eventually fail") {
//                expect("time").toEventually( equal("done") )
//            }
//
//            context("these will pass") {
//
//                it("can do maths") {
//                    expect(23) == 23
//                }
//
//                it("can read") {
//                    expect("🐮") == "🐮"
//                }
//
//                it("will eventually pass") {
//                    var time = "passing"
//
//                    DispatchQueue.main.async {
//                        time = "done"
//                    }
//
//                    waitUntil { done in
//                        Thread.sleep(forTimeInterval: 0.5)
//                        expect(time) == "done"
//
//                        done()
//                    }
//                }
//            }
        }
    }
    
}
