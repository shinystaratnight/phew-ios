//
//  MyFriendsTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/27/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
protocol MyFriendsTableViewCellProtocol: AnyObject {
    func removeFriend(id: Int)
}


class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var btnRemoveOutlet: UIButton!
    
    weak var deleget: MyFriendsTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var item: FriendsModel! {
        didSet{
            lblDate.text = "Friend from ".localize +  (item.date ?? "")
            lblName.text = item.user?.fullname
            imageUser.load(with: item.user?.profileImage)
        }
    }
    
    var itemUser: User! {
        didSet{
            lblDate.text = "Friend from ".localize
            lblName.text = itemUser.fullname
            imageUser.load(with: itemUser.profileImage)
            btnRemoveOutlet.isHidden = true
        }
    }
    @IBAction func btnRemoveTappped(_ sender: Any) {
        deleget?.removeFriend(id: item.user?.id ?? 0)
    }
}
