//
//  ViewLike2.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/30/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit

class ViewLike2 {
    private var view: UIView
    private var one = 0...117
    private var two = 118...165
    private var three = 166...219
    
    var didSelectReact: ((String?) -> Void)?
    private var arrImages = [UIImageView(image:#imageLiteral(resourceName: "laugh")), UIImageView(image:#imageLiteral(resourceName: "love")).withTint(.mainRed), UIImageView(image:#imageLiteral(resourceName: "dislike")) ]
    private var containerzview: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.withHeight(40)
        v.withWidth(150)
        v.layer.cornerRadius = 20
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = .zero
//        v.layer.shadowRadius = 10
        return v
    }()
    init(view: UIView ) {
        self.view = view
       
    }
    
    func setView(leadingAnchor: NSLayoutXAxisAnchor, bouttomAnchor: NSLayoutXAxisAnchor ) {
        view.addSubview(containerzview)
        containerzview.leadingAnchorToView(anchor: view.leadingAnchor, constant: 70)
        containerzview.bottomAnchorSuperView(constant: 23)
//        containerzview.backgroundColor = .red
        let stack = UIStackView(arrangedSubviews: arrImages)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 15
        
        containerzview.addSubview(stack)
        stack.centerXInSuperview()
        stack.centerYInSuperview()
        
        arrImages.forEach({
            $0.withWidth(30)
            $0.withHeight(30)
        })
        
        containerzview.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerzview.alpha = 1
//            self.containerzview.transform = self.containerzview.transform.translatedBy(x: 0, y: -30)
        })
    }
    
    func remove() {
        self.didSelectReact?(Helper.getNameReact(tag: current))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.containerzview.transform = self.containerzview.transform.translatedBy(x: 0, y: 10)
            self.containerzview.alpha = 0
        }, completion: { (_) in
            self.containerzview.removeFromSuperview()
        })
    }
    var current: Int = -999
    func animation(location: CGFloat) {
        let value = Int(location)
        print(value)
        if current == getNewPosistion(value: value) {
            
        }else{
            arrImages.forEach({
                $0.backgroundColor = .clear
                $0.transform = .identity
            })
            
            if one.contains(value) {
                animationImage(image: arrImages[0])
                current = 0
            }else if two.contains(value) {
                animationImage(image: arrImages[1])
                current = 1
            }else {
                animationImage(image: arrImages[2])
                current = 2
            }
        }
    }
    
    private func animationImage(image: UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            image.transform = CGAffineTransform(translationX: 0, y: -50)
            image.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
    private func getNewPosistion(value: Int) -> Int {
        if one.contains(value) {
            return 0
        }else if two.contains(value) {
            return 1
        }else {
            return 2
        }
    }
}
