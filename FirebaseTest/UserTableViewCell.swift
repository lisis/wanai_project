//
//  UserTableViewCell.swift
//  FirebaseTest
//
//  Created by Ivan Leider on 25/05/2017.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate: class {
    func userCellFollowButtonPressed(sender: UserTableViewCell)
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    weak var delegate: UserTableViewCellDelegate?
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.userCellFollowButtonPressed(sender: self)
        }
    }

}





