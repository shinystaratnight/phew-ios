//
//  CitiesTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 9/13/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCountReact: UILabel!
    @IBOutlet weak var imageReact: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var item: CityModel! {
        didSet{
            lblCityName.text = item.name
            lblCountReact.text = String(item.likeCount ?? 0)
            imageReact.image = UIImage(named: item.likeType ?? Helper.getNameReact(tag: 2))
        }
    }
}
