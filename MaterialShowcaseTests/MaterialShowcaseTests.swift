//
//  MaterialShowcaseTests.swift
//  MaterialShowcaseTests
//
//  Created by Veli Bacik on 16.04.2019.
//  Copyright © 2019 Aromajoin. All rights reserved.
//

import XCTest
import MaterialShowcase

class MaterialShowcaseTests: XCTestCase {

    func testUserState() {
//        if is it true no retry animation else always retry
        let showcase = MaterialShowcase()
        showcase.setUserState(save: true)
        XCTAssertEqual(true, showcase.getUserState())
    
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
