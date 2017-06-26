//
//  UpdateContactVC.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

class UpdateContactVC: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {

    /// Tag view information

    /// 11 - Container view

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    var activityIndicator = UIActivityIndicatorView()
    var contactCreationHandler: ((ContactObject) -> Void)?
    var contactUpdationHandler: ((ContactObject) -> Void)?
    var picker: UIImagePickerController? = UIImagePickerController()
    var currentObject: ContactObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        doNavBarDesigns()
        applyYGradientColorForContainerView()
        setUpActivityIndicator()
        picker?.delegate=self
        if currentObject != nil {
            populateValuesFromCurrentObject()
        }
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

    func populateValuesFromCurrentObject() {
        if let info = currentObject {
            firstNameField.text = info.firstName
            lastNameField.text = info.lastName
            mobileField.text = info.mobile
            emailField.text = info.email
        }
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

        guard (emailField.text?.characters.count)! > 0 else {
            showAlertViewController("Email field is mandatory !")
            return
        }

        guard checkIfPhoneNumberIsValid() else {
            showAlertViewController("Invalid Phone number !")
            return
        }

        guard checkIfEmailIsValid() else {
            showAlertViewController("Invalid Email ID !")
            return
        }

        if currentObject == nil {
            createContactAPICall()
        } else {
            updateContactAPICall()
        }
    }

    @IBAction func uploadImageButtonClicked(sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func OpenGallery(sender: AnyObject) {
        openGallary()
    }

    // Take Photo button click
    @IBAction func TakePhoto(sender: AnyObject) {
        openCamera()
    }

    // MARK: Other Functionality Methods

    func prepareCreateContactObject() -> [String: Any] {
        var contactInfo: [String: Any] = [:]
            contactInfo["first_name"] = firstNameField.text
            contactInfo["last_name"] = lastNameField.text
            contactInfo["email"] = emailField.text
            contactInfo["phone_number"] = mobileField.text
        return contactInfo
    }

    func checkWhetherTheContactUpdated() -> Bool {
        if let info = currentObject {
            if info.firstName != firstNameField.text || info.lastName != lastNameField.text || info.email != emailField.text || info.mobile != mobileField.text {
                return true
            }
        }
        return false
    }

    func openGallary() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }


    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: Validation Methods

    func checkIfEmailIsValid() -> Bool {
        if emailField.text?.characters.count == 0 {
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailField.text)
    }

    func checkIfPhoneNumberIsValid() -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = mobileField.text?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        return  mobileField.text == filtered && mobileField.text?.characters.count ?? 0 >= 10
    }

    // MARK: API Methods

    func createContactAPICall() {
        activityIndicator.startAnimating()
        APIManager.createContactDetail(prepareCreateContactObject(), nil) {
            response, error in
            self.activityIndicator.stopAnimating()
            if error == nil {
                if let info = response {
                    if self.contactCreationHandler != nil {
                        self.contactCreationHandler!(info)
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showAlertViewController("Request failed !")
            }
        }
    }

    func updateContactAPICall() {
        if checkWhetherTheContactUpdated() {
            activityIndicator.startAnimating()
            APIManager.createContactDetail(prepareCreateContactObject(), currentObject?.id) {
                response, error in
                self.activityIndicator.stopAnimating()
                if error == nil {
                    if let info = response {
                        if self.contactUpdationHandler != nil {
                            self.contactUpdationHandler!(info)
                        }
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showAlertViewController("Request failed !")
                }
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

    // MARK: Picker View Delegate Methods

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

}
