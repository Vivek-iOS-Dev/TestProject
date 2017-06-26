//
//  ContactsList.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 26/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import XCTest
@testable import TestProject

class ContactsLisVC: XCTestCase {
    var contactInfo: ContactObject?

    override func setUp() {
        super.setUp()
        contactInfo?.mobile = "fasd232"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {

    }

    func testMobileNumberIsValid() {
        XCTAssertNotNil(Int((contactInfo?.mobile)!) == 0, "Invalid Mobile Number !")
    }

    func testViewDidLoadPerfectly() {
        let contactsListVC = ContactListVC()

        XCTAssertNotNil(contactsListVC.view, "Error in View load")

    }

    func testPerformanceExample() {
        self.measure {
            }
    }
    
}
