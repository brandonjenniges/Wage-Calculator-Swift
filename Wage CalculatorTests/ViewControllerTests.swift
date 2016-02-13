//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import XCTest
@testable import Wage_Calc

class ViewControllerTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateInitialViewController() as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(viewController, "Unable to create view controller from Storyboard")
    }
    
    func testLoad() {
        let _ = viewController.view
        viewController.viewDidLoad()
        viewController.viewWillAppear(true)
        viewController.viewDidAppear(true)
    }
    
    func testPlayButtonPress() {
        MoneyCalculator.saveWage(20.0)
        viewController.play(self)
        XCTAssertNotNil(viewController.timer.timer, "Timer wasn't started")
    }
    
    func testPauseButton() {
        viewController.pause(self)
        XCTAssert(!viewController.timer.timer.valid, "Timer wasn't invalidated on pause")
    }
    
    func testClearButton() {
        viewController.clear(self)
        XCTAssert(!viewController.timer.timer.valid, "Timer wasn't invalidated on clear")
    }
    
}
