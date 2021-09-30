//
//  FriendNameCollectionViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/17/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol FriendNameCollectionViewCellProtocol:AnyObject {
    func deleteFriend(cell:FriendNameCollectionViewCell)
    
}
class FriendNameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    weak var deleget:FriendNameCollectionViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        deleget?.deleteFriend(cell: self)
    }
    
    var item:User!{
        didSet{
            lblName.text = item.fullname
        }
    }
    

}
