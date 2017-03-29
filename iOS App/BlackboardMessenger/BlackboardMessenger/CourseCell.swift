//
//  CourseCell.swift
//  BlackboardMessenger
//
//  Created by William Wu on 3/28/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
	@IBOutlet weak var courseName: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
