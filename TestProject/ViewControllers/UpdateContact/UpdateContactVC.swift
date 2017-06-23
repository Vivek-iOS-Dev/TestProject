//
//  UpdateContactVC.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

class UpdateContactVC: UIViewController {

    /// Tag view information

    /// 11 - Container view

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    var activityIndicator = UIActivityIndicatorView()
    var contacCreationHandler: ((ContactObject) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        doNavBarDesigns()
        applyYGradientColorForContainerView()
        setUpActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: UI Design Methods

    func doNavBarDesigns() {
        self.navigationController?.navigationBar.backItem?.title = "Cancel"
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneButtonClicked))
        navigationItem.rightBarButtonItem  = rightBarButton
        navigationController?.navigationBar.tintColor = UIColor.appLightGreenColor()
        navigationController?.navigationBar.barTintColor = UIColor.white
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false
    }

    func applyYGradientColorForContainerView() {
        let cView = view.viewWithTag(11)
        let colorTop = UIColor.white.cgColor
        let colorBottom = UIColor.appLightGreenColor().withAlphaComponent(0.5).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: (cView?.frame.size.width)!, height: (cView?.frame.size.height)!)
        cView?.layer.insertSublayer(gradient, at: 0)
    }

    func setUpActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    // MARK: UI User Interaction Methods

    func doneButtonClicked() {
        guard (firstNameField.text?.characters.count)! > 0 else {
            showAlertViewController("First name field is mandatory !")
            return
        }

        guard (mobileField.text?.characters.count)! > 0 else {
            showAlertViewController("Mobile field is mandatory !")
            return
        }

        createContactAPICall()
    }

    // MARK: Other Functionality Methods

    func prepareCreateContactObject() -> [String: Any] {
        var contactInfo: [String: Any] = [:]
            contactInfo["first_name"] = firstNameField.text
            contactInfo["last_name"] = lastNameField.text
            contactInfo["email"] = emailField.text
            contactInfo["phone_number"] = mobileField.text
            contactInfo["profile_pic"] = ""
        return contactInfo
    }


    func createContactAPICall() {
        activityIndicator.startAnimating()
        APIManager.createContactDetail(prepareCreateContactObject()) {
            response, error in
            self.activityIndicator.stopAnimating()
            if error == nil {
                if let info = response {
                    if self.contacCreationHandler != nil {
                        self.contacCreationHandler!(info)
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showAlertViewController("Request failed !")
            }
        }
    }

    // MARK: Alert View Methods

    func showAlertViewController(_ message: String) {
        if message.characters.count == 0 {
            return
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
