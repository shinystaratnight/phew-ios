//
//  FriendsNotificationsTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol FriendsNotificationsDelegate: AnyObject {
    func acceptButtonTapped(cell: FriendsNotificationsTableViewCell)
    func cancelButtonTapped(cell: FriendsNotificationsTableViewCell)
}

class FriendsNotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var requestFriendLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    private var id: Int = 0
    weak var delegate: FriendsNotificationsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateView()
    }
    
    var dataItem: NotificationModel! {
        didSet{
            avatar.load(with: dataItem?.senderData?.profileImage)
            dateLbl.text  = dataItem?.createdTime
            requestFriendLbl.text = dataItem.body
            id = dataItem.senderData?.id ?? 0
        }
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        delegate?.acceptButtonTapped(cell: self)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        delegate?.cancelButtonTapped(cell: self)
    }
    
    var item: FriendsModel? {
        didSet{
            id = item?.user?.id ?? 0
            avatar.load(with: item?.user?.profileImage)
            requestFriendLbl.text = item?.user?.fullname
            dateLbl.text = item?.date
        }
    }
}

extension FriendsNotificationsTableViewCell {
    
    private func updateView() {
        selectionStyle = .none
        avatar.image = #imageLiteral(resourceName: "crush")
        
        acceptBtn
            .withFont(.CairoBold(of: 15))
            .withTitleColor(#colorLiteral(red: 0.2156862745, green: 0.831372549, blue: 0.09803921569, alpha: 1))
        
        cancelBtn
            .withFont(.CairoBold(of: 15))
            .withTitleColor(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
    }
}
