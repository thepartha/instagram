//
//  FeedTableViewCell.swift
//  instagram
//
//  Created by Partha Sarathy on 5/30/20.
//  Copyright © 2020 Partha Sarathy. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet var postedImage: UIImageView!
    
    @IBOutlet var userInfo: UILabel!
    @IBOutlet var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
