//
//  ChatTableViewCell.swift
//  Caberz
//
//  Created by Ahmed Elesawy on 12/10/20.
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {
    
    private  let imageSender = UIImageView()
   private let imageMessage = UIImageView()
    private let lblDate =  UILabel(text: "10-10-2020", font: .systemFont(ofSize: 9) , textColor: .lightGray)
    private let view = UIView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func setView(){
        // conatiner view
        addSubview(view)
        view.fillSuperview(padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        view.backgroundColor = .clear
        backgroundColor = .clear
        
        // set image
        view.addSubview(imageSender)
        imageSender.withWidth(20)
        imageSender.withHeight(20)
        
        imageSender.layer.cornerRadius = 10
        imageSender.clipsToBounds = true
        
        let stakChat = UIStackView(arrangedSubviews: [imageMessage, lblDate])
        stakChat.axis = .vertical
        stakChat.alignment = .leading
        stakChat.distribution = .fill
        stakChat.spacing = 5
        // chat View
        let stack = UIStackView(arrangedSubviews: [imageSender, stakChat])
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fill
        stack.spacing = 5
        
        
        view.addSubview(stack)
        imageSender.image = #imageLiteral(resourceName: "placeHolder")
        
        stack.leadingAnchorToView(anchor: view.leadingAnchor, constant: 0)
        stack.topAnchorToView(anchor: view.topAnchor, constant: 0)
        stack.bottomAnchorToView(anchor: view.bottomAnchor)
        imageMessage.withWidth(300)
        imageMessage.withHeight(100)
        imageMessage.layer.cornerRadius = 10
    }
    
    var item: ChatViewModel! {
        didSet{
            imageMessage.clipsToBounds = true
            imageMessage.load(with: item.message)
            lblDate.text = item.date
            imageSender.load(with: item.avatar)
            imageMessage.layer.cornerRadius = 10
            if item.userType == .you {
               
                view.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                lblDate.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                imageMessage.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                imageSender.isHidden = false
            }else{
                view.layer.setAffineTransform(.identity)
                imageSender.isHidden = true
                lblDate.layer.setAffineTransform(.identity)
                imageMessage.layer.setAffineTransform(.identity)
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
