//
//  MoviePostTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class PostWatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: CircleImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    var dataItem: MoviFilm? {
        didSet{
            movieName.text = dataItem?.title
            movieStatus.text = "Number of people vote it ".localize + (String(dataItem?.voteCount ?? 0) )
            let imageUrl = "https://image.tmdb.org/t/p/original/\(String(describing: dataItem?.posterPath ?? ""))"
            avatar.load(with: imageUrl)
            
        }
    }
}
