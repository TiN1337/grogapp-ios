//
//  StatusTableViewCell.swift
//  GroGApp
//
//  Created by Justin Daigle on 2/7/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    @IBOutlet var authorLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var avatarView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
