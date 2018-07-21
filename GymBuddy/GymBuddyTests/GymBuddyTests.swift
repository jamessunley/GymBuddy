//
//  GymBuddyTests.swift
//  GymBuddyTests
//
//  Created by James Sunley on 29/01/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import XCTest
@testable import GymBuddy

class GymBuddyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBMIHealthy() {
        let height = 175.5
        let weight = 65
        let bmiresult = ProfileViewController().bmi(height: Double(height), weight: Double(weight))
        print(bmiresult)
        
        XCTAssertEqual(bmiresult, "Your BMI is: 21.1. This means you are of a healthy weight")
        
    }
    
    func testBMIUnderweight() {
        let height = 170.1
        let weight = 50
        let bmiresult = ProfileViewController().bmi(height: Double(height), weight: Double(weight))
        print(bmiresult)
        
        XCTAssertEqual(bmiresult, "Your BMI is: 17.28. This means you are underweight.")
        
    }
    
    func testBMIOverweight() {
        let height = 170.1
        let weight = 77.3
        let bmiresult = ProfileViewController().bmi(height: Double(height), weight: Double(weight))
        print(bmiresult)
        
        XCTAssertEqual(bmiresult, "Your BMI is: 26.72. This means you are overweight")
    }
    
    func testBMIObese() {
        let height = 170.1
        let weight = 90.9
        let bmiresult = ProfileViewController().bmi(height: Double(height), weight: Double(weight))
        print(bmiresult)
        
        XCTAssertEqual(bmiresult, "Your BMI is: 31.42. This means you are obese")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
