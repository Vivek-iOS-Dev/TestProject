//
//  ContactListVC.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /// Class Constants

    let cellIdentifier = "ContactsListTableCell"
    let cellHeight:CGFloat = 60
    var contactsList: [ContactObject] = []
    var activityIndicator = UIActivityIndicatorView()

    /// Class Outlets

    @IBOutlet weak var contactsListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        doNavBarDesigns()
        setupTableView()
        getContactsListFromServer()
        setUpActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UI Design Methods

    func doNavBarDesigns() {
        title = "Contacts"
        let leftBarButton = UIBarButtonItem(title: "Groups", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.leftBarButtonItem  = leftBarButton
        let rightBarButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addContactButtonClicked))
        navigationItem.rightBarButtonItem  = rightBarButton
        navigationController?.navigationBar.tintColor = UIColor.appLightGreenColor()
    }

    func setUpActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    // MARK: UI User Interaction Methods

    func leftBarButtonClicked() {
        
    }

    func addContactButtonClicked() {

    }

    // MARK: Other Functionality Methods

    func navigateToDetailVC(_ index: Int) {
        let detailVC = ContactDetailVC()
        detailVC.contactId = contactsList[index].id
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: UITableView Setup Methods

    func setupTableView() {
        contactsListTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - UITableView Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ContactsListTableCell)!
        infoCell.selectionStyle = .none
        infoCell.updateCell(contactsList[indexPath.row])
        return infoCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetailVC(indexPath.row)
    }

    // MARK: API Calls

    func getContactsListFromServer() {
        activityIndicator.startAnimating()
        APIManager.getListOfContacts() {
            response, error in
            self.activityIndicator.stopAnimating()
            if error == nil {
                if let info = response {
                    self.contactsList = info
                    self.contactsListTableView.reloadData()
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
