//
//  SponsorTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/18/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class SponsorTableViewCell: UITableViewCell {

    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var viewContainer: ViewShaow!
    
    weak var delegate: HomeCellsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        viewContainer.layer.cornerRadius = 5
        viewButtom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageBanner.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageBanner.layer.cornerRadius = 5
        viewButtom.layer.cornerRadius = 5
    }
    
    var item:HomeModel? {
        didSet {
            lblName.text = item?.sponsor?.name ?? "No set"
            imageIcon.load(with: item?.sponsor?.logo)
            lblDesc.text = item?.desc ?? ""
            
            if let type = item?.type, type == "video" {
                imageBanner.load(with: item?.thumbnail)
            }else {
                imageBanner.load(with: item?.file)
            }
        }
    }
    
    @IBAction func btnVisitWebSiteTapped(_ sender: Any) {
        guard let url = URL(string: item?.url ?? "") else {return}
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnDeleteAdvTapped(_ sender: Any) {
        delegate?.didTappedDeleteAdv(cell: self)
    }
    
}
