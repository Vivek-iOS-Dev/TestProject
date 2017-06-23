//
//  APIManager.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

    /// API Constants

    let appBaseURL = "http://gojek-contacts-app.herokuapp.com/"

class APIManager: NSObject {

    // MARK: API Calls

    static func getListOfContacts(completionHandler:@escaping ([ContactObject]?, String?) -> Void) {
        URLSession.shared.dataTask(with: prepareRequestForGetContacts()) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error?.localizedDescription)
                return
            }

            guard let data = data else {
                completionHandler(nil, "Invalid Response")
                return
            }

            if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? Array<Any> {
                DispatchQueue.main.async {
                    completionHandler(ContactObject.prepareContactsObjectModels(json), nil)
                }
                return
            }

            completionHandler(nil, "Invalid Response")

            }.resume()
    }

    static func getContactDetail(_ contactId: Int, completionHandler:@escaping (ContactObject?, String?) -> Void) {
        URLSession.shared.dataTask(with: prepareRequestForGetContactDetail(contactId)) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error?.localizedDescription)
                return
            }

            guard let data = data else {
                completionHandler(nil, "Invalid Response")
                return
            }

            if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    let contactInfo = ContactObject(objectInfo: json)
                    completionHandler(contactInfo, nil)
                }
                return
            }

            completionHandler(nil, "Invalid Response")
            
            }.resume()
    }

    static func createContactDetail(_ contactInfo: [String: Any], completionHandler:@escaping (ContactObject?, String?) -> Void) {
        URLSession.shared.dataTask(with: prepareRequestForCreateContactDetail(contactInfo)) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error?.localizedDescription)
                return
            }

            guard let data = data else {
                completionHandler(nil, "Invalid Response")
                return
            }

            if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    let contactInfo = ContactObject(objectInfo: json)
                    completionHandler(contactInfo, nil)
                }
                return
            }

            completionHandler(nil, "Invalid Response")
            
            }.resume()
    }

    // MARK: API Request Makers

    static func prepareRequestForGetContacts() -> URLRequest {
        var request = URLRequest(url: URL(string: "\(appBaseURL)contacts.json")!)
        request.httpMethod = "GET"
        return request
    }

    static func prepareRequestForGetContactDetail(_ contactId: Int) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(appBaseURL)contacts/\(contactId).json")!)
        request.httpMethod = "GET"
        return request
    }

    static func prepareRequestForCreateContactDetail(_ contactInfo: [String: Any]) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(appBaseURL)contacts.json")!)
        request.httpBody = NSKeyedArchiver.archivedData(withRootObject: contactInfo)
        request.httpMethod = "POST"
        return request
    }

   
}
