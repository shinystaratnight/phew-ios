//
//  PackagesTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 3/8/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class PackagesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageBackgorund: UIImageView!
    @IBOutlet weak var viewBackground: UIView! {
            didSet{
                viewBackground.layer.cornerRadius = 10
            }
        }
        @IBOutlet weak var lblPackagePrice: UILabel!
        @IBOutlet weak var lblPackageDuration: UILabel!
        @IBOutlet weak var lblDurationText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var item: PackageModel! {
        didSet {
            lblPackageDuration.text = "\(item.period ?? "") \(item.periodType ?? "")"

            if let selected = item.isSelected, selected {
                [lblPackageDuration, lblPackagePrice, lblDurationText].forEach({
                    $0?.textColor = .white
                })
                imageBackgorund.image = UIImage(named: "bg_pack")

            }else {
                [lblPackageDuration, lblPackagePrice, lblDurationText].forEach({
                    $0?.textColor = .mainColor
                })
                imageBackgorund.image = UIImage(named: "bg_packw")
               
            }
        }
    }
}


extension UIView {

    func applyGradient(colors: [CGColor] = [#colorLiteral(red: 0.9606800675, green: 0.9608443379, blue: 0.9606696963, alpha: 1).cgColor,
                                            #colorLiteral(red: 0.9724436402, green: 0.972609818, blue: 0.9724331498, alpha: 1).cgColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
