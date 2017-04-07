//
//  MessageCell.swift
//  BlackboardMessenger
//
//  Created by William Wu on 4/6/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
	@IBOutlet weak var messageContent: UITextView!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var outgoingCell: UILabel!
	@IBOutlet weak var outgoingMessage: UITextView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
