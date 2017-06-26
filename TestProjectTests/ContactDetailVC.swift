//
//  ContactDetailVC.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 26/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import XCTest
import MessageUI

class ContactDetailVC: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testMailComposer() {
        XCTAssertTrue(MFMailComposeViewController.canSendMail(), "Mail composer not available !")
    }

    func testMessageComposer() {
        XCTAssertTrue(MFMessageComposeViewController.canSendText(), "Message composer not available !")
    }

    func testCallComposer() {
        XCTAssertTrue(UIApplication.shared.canOpenURL(URL(string: "tel://+91239234234")!), "Call option not available !")

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
