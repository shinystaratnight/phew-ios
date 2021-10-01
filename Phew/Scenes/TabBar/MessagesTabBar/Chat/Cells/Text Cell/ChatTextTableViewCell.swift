//
//  ChatTableViewCell.swift
//  Caberz
//
//  Created by Ahmed Elesawy on 12/10/20.
//

import UIKit

class ChatTextTableViewCell: UITableViewCell {
    
    private  let imageSender = UIImageView()
    private let lblMessage = UILabel(text: "test test est test est", font: .CairoRegular(of: 14), textColor: .black).lineZero
    private let lblDate =  UILabel(text: "10-10-2020", font: .CairoRegular(of: 9), textColor: .lightGray)
    private let view = UIView()
    private let viewChat  = UIView()
    
    
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
        
        // chat View
        let stack = UIStackView(arrangedSubviews: [imageSender, viewChat])
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fill
        stack.spacing = 5
        
        view.addSubview(stack)
        imageSender.image = #imageLiteral(resourceName: "placeHolder")
        
        stack.leadingAnchorToView(anchor: view.leadingAnchor, constant: 0)
        stack.topAnchorToView(anchor: view.topAnchor, constant: 0)
        stack.bottomAnchorToView(anchor: view.bottomAnchor)
       
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            viewChat.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        let stackChat = UIStackView(arrangedSubviews: [lblMessage, lblDate])
        stackChat.axis = .vertical
        stackChat.alignment = .leading
        stackChat.distribution = .fill
        viewChat.addSubview(stackChat)
        viewChat.backgroundColor = .mainColor
        stackChat.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10))
    }
    
    var item: ChatViewModel! {
        didSet{
            lblMessage.text = item.message
            lblDate.text = item.date
            imageSender.load(with: item.avatar)
            viewChat.layer.cornerRadius = 10
            if item.userType == .you {
                viewChat.backgroundColor = .mainColor
                view.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                lblMessage.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                lblDate.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                imageSender.isHidden = false
                lblMessage.textColor = .white
            }else{
                viewChat.backgroundColor = .backgroundCellColor
                view.layer.setAffineTransform(.identity)
                lblMessage.layer.setAffineTransform(.identity)
                lblDate.layer.setAffineTransform(.identity)
                imageSender.isHidden = true
                lblMessage.textColor = .mainBlack
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
