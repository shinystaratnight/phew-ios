//
//  MessagesTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 9/13/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUser: CircleImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    var item: ConversationModel! {
        didSet {
            imageUser.load(with: item.senderData?.profileImage)
            lblName.text = item.senderData?.fullname
            lblMessage.text = item.lastMessage
            lblDate.text = item.createdAt
        }
    }
}
