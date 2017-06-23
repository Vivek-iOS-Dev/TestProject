//
//  ContactObject.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

class ContactObject {

    var favorite = false
    var firstName = ""
    var id = 0
    var lastName = ""
    var profilePic = ""
    var URL = ""
    var email = ""
    var mobile = ""

    init(objectInfo: [String: Any]) {
        self.favorite = objectInfo["favorite"] as? Bool ?? false
        self.firstName = objectInfo["first_name"] as? String ?? ""
        self.id = objectInfo["id"] as? Int ?? 0
        self.lastName = objectInfo["last_name"] as? String ?? ""
        self.profilePic = objectInfo["profile_pic"] as? String ?? ""
        self.URL = objectInfo["url"] as? String ?? ""
        self.email = objectInfo["email"] as? String ?? ""
        self.mobile = objectInfo["phone_number"] as? String ?? ""
    }

    // MARK: Parsing Model Objects

    static func prepareContactsObjectModels(_ arrayInfo: Array<Any>) -> [ContactObject] {
        var contactsList: [ContactObject] = []
        for object in arrayInfo where ((object as? [String: Any]) != nil) {
            let objectModel = ContactObject(objectInfo: object as! [String : Any])
            contactsList.append(objectModel)
        }
        return contactsList
    }

}
