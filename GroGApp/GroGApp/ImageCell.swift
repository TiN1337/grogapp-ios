//
//  ImageCell.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/28/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet var imageViewer:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
