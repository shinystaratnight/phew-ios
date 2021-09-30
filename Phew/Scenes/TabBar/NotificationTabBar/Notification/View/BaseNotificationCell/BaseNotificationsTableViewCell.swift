//
//  BaseNotificationsTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class BaseNotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    var dataItem: NotificationModel! {
        didSet{
            avatar.load(with: dataItem.senderData?.profileImage)
            statusLbl.text = dataItem.body
            dateLbl.text    = dataItem.createdTime
            handleCell(key: dataItem.key ?? "")
        }
    }
    
    private func handleCell(key: String) {
        switch  key {
        case NotificationKeys.retweet.rawValue:
            statusImage.image = #imageLiteral(resourceName: "echo_post")
        case NotificationKeys.like.rawValue:
            statusImage.image = #imageLiteral(resourceName: "laugh")
        case NotificationKeys.comment.rawValue:
            statusImage.image = #imageLiteral(resourceName: "Group 1449")
        case NotificationKeys.follow.rawValue:
            if #available(iOS 13.0, *) {
                statusImage.image = #imageLiteral(resourceName: "followers").withTintColor(.mainColor)
            } else {
                statusImage.image = #imageLiteral(resourceName: "followers")
                // Fallback on earlier versions
            }
        break
            //followers
        default:
            break
        }
    }
    
}
