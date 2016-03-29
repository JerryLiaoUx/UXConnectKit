//
//  UXConnectKitTests.swift
//  UXConnectKitTests
//
//  Created by uitox_macbook on 2016/3/23.
//  Copyright © 2016年 uitox. All rights reserved.
//

import XCTest
@testable import UXConnectKit

class UXConnectKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCallApiGetWebConfig() {
		
		MyApp.sharedWebsiteConfigModel.callApiGetWebConfig(highPriorityDispatchQueue) { (resp, errorMessage) -> Void in
			log.debug("dispatch_group_leave2")
		}

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
