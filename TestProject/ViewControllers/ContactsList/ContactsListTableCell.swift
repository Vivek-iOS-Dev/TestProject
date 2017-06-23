//
//  ContactsListTableViewCell.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

class ContactsListTableCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favIcon: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: Cell Updates

    func updateCell(_ info: ContactObject) {
        if info.favorite {
            favIcon.image = UIImage.favIconImage()
        } else {
            favIcon.image = nil
        }
        contactNameLabel.text = "\(info.firstName) \(info.lastName)"
        profileImageView.image = UIImage.imageFromURL(info.profilePic)
    }
    
}
