//
//  UnknowMessagesTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/23/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class UnknowMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var item: SectertMessages! {
        didSet {
            lblDate.text = item.createdAt
            lblMessage.text = "Message #".localize + String(item.id ?? 0)
            lblBody.text = item.message ?? ""
        }
    }
}
