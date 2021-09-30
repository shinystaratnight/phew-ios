//
//  AudioTableViewCell.swift
//  Phew

import UIKit

protocol AudioTableViewCellProtocol: AnyObject {
    func playAudioTapped(cell: AudioTableViewCell)
}

class AudioTableViewCell: UITableViewCell {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnAudioOutlet: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var viewTimeAudio: AnimatingV!
    @IBOutlet weak var lblDate: UILabel!
    
    weak var deleget: AudioTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func btnPlayAudioTapped(_ sender: Any) {
        deleget?.playAudioTapped(cell: self)
    }
    
    var item: ChatViewModel! {
        didSet {
            imageAvatar.load(with: item.avatar)
            lblDate.text = item.date
            setLoader(isLoader: item.isDownloadNow)
            viewContainer.layer.cornerRadius = 10
            guard item.isDownloadNow == false else {return}
            if item.isPlayAudio {
                print("play")
                btnAudioOutlet.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
                viewTimeAudio.animate(time: item.durationTime ?? 0.0)
                viewTimeAudio.backgroundColor = .black
            }else {
                print("stoop")
                btnAudioOutlet.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                viewTimeAudio.stopAnimation()
                viewTimeAudio.backgroundColor = #colorLiteral(red: 1, green: 0.9810138345, blue: 0.9432478547, alpha: 1)
                viewTimeAudio.layoutIfNeeded()
            }
            
            if item.userType == .you {
                if AuthService.isArabic {
                    viewContainer.cornerRadiusViewChat()
                }else {
                    viewContainer.cornerRadiusViewChatAnother()
                }
                imageAvatar.isHidden = false
                lblDate.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                btnAudioOutlet.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                self.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))

            }else {
                
                imageAvatar.isHidden = true
//                self.layer.setAffineTransform(.identity)
                btnAudioOutlet.layer.setAffineTransform(.identity)
//                viewContainer.layer.setAffineTransform(.identity)
                lblDate.layer.setAffineTransform(.identity)
                self.layer.setAffineTransform(.identity)
            }
        }
    }
    
    private func setLoader(isLoader: Bool) {
        if isLoader {
            loader.isHidden = false
            btnAudioOutlet.isHidden = true
            loader.startAnimating()
            
        }else{
            loader.isHidden = true
            btnAudioOutlet.isHidden = false
            loader.stopAnimating()
        }
    }

}
