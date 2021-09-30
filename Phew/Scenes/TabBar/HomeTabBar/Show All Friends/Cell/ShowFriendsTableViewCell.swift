//
//  ShowFriendsTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
protocol ShowFriendsTableViewCellProtocol: AnyObject {
    func followUser(userId: Int)
}

class ShowFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnFollowOutlet: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    weak var deleget:ShowFriendsTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }
    
    var item: User! {
        didSet{
            lblName.text = item.fullname ?? ""
            imageUser.load(with: item.profileImage)
            
           
            if let isfollow = item.isFollow, isfollow {
                btnFollowOutlet.setTitle("Unfollow".localize, for: .normal)
            }else{
                btnFollowOutlet.setTitle("Follow".localize, for: .normal)
            }
        }
    }
    
    @IBAction func btnFollowTappe(_ sender: Any) {
        deleget?.followUser(userId: item.id ?? 0)
    }
}
