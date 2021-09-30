//
//  LocationPostTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class LocationOnMapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var numberOfPeopleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    var dataItem: MapsSearchData? {
        didSet{
            placeName.text         = dataItem?.name
            distanceLbl.text       = dataItem?.formattedAddress
//            numberOfPeopleLbl.text = dataItem?.email
        }
    }
}
