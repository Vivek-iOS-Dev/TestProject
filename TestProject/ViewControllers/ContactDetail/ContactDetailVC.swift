//
//  ContactDetailVC.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

class ContactDetailVC: UIViewController {

    /// Tag view information

    /// 11 - Container view

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var contactId = 0
    var activityIndicator = UIActivityIndicatorView()
    var currentContactInfo: ContactObject?
    var contactUpdationHandler: ((ContactObject) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        doNavBarDesigns()
        applyYGradientColorForContainerView()
        setUpActivityIndicator()
        getContactsListDetailFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UI Design Methods

    func doNavBarDesigns() {
        self.navigationController?.navigationBar.backItem?.title = "Contacts"

        let rightBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editButtonClicked))
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

    func editButtonClicked() {
        let addContactsVC = UpdateContactVC()
        addContactsVC.currentObject = currentContactInfo
        addContactsVC.contactUpdationHandler = { response in
                self.currentContactInfo = response
                self.updateCurrentContactInfo()
            if self.contactUpdationHandler != nil {
                self.contactUpdationHandler!(response)
            }

        }
        navigationController?.pushViewController(addContactsVC, animated: true)
    }

    // MARK: Other Functionality methods

    func updateCurrentContactInfo() {
        if let info = currentContactInfo {
            contactNameLabel.text = "\(info.firstName) \(info.lastName)"
            profileImageView.image = UIImage.imageFromURL(info.profilePic)
            mobileLabel.text = info.mobile
            emailLabel.text = info.email
            if info.favorite {
                favImageView.image = UIImage.enableFavIconImage()
            } else {
                favImageView.image = UIImage.disableFavIconImage()
            }
        }
    }

    // MARK: API Calls

    func getContactsListDetailFromServer() {
        activityIndicator.startAnimating()
        APIManager.getContactDetail(contactId) {
            response, error in
            self.activityIndicator.stopAnimating()
            if error == nil {
                if let info = response {
                    self.currentContactInfo = info
                    self.updateCurrentContactInfo()
                } else {
                    self.showAlertViewController("Invalid Response !")
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
