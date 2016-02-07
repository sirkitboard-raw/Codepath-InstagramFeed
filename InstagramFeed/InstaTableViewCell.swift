//
//  InstaTableViewCell.swift
//  InstagramFeed
//
//  Created by Aditya Balwani on 1/28/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit
import AFNetworking

class InstaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var instaImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
