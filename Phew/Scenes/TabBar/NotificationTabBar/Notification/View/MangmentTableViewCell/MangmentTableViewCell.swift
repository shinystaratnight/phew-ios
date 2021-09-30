//
//  MangmentTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 9/13/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class MangmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var dataItem: NotificationModel! {
        didSet{
            messageLbl.text = dataItem?.body
            dateLbl.text    = dataItem.createdTime
        }
    }
}
