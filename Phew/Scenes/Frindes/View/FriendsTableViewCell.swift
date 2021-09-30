//
//  FriendsTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol FriendsTableViewDelegate: AnyObject {
    func deleteFriend(id: Int)
}

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: CircleImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    weak var delegate: FriendsTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateView()
    }
    
    var dataItem: UserData? {
        didSet{
            avatar.load(with: dataItem?.profileImage)
            userName.text   = dataItem?.email
            userStatus.text = dataItem?.email
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        delegate?.deleteFriend(id: 1)
    }
}

extension FriendsTableViewCell {
    
    private
    func updateView() {
        userName
            .withFont(.CairoBold(of: 15))
        userStatus
            .withFont(.CairoRegular(of: 14))
        
        deleteBtn
            .withFont(.CairoRegular(of: 15))
            .viewBorderColor = .mainRed
        
        deleteBtn.viewBorderWidth = 0.7
        deleteBtn.viewCornerRadius = 6
    }
    
}
