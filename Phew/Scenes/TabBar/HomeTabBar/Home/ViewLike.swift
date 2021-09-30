//
//  ViewLike.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/30/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit

class ViewLike {
    
    private var view: UIView
    private var btn: UIButton
    var didSelectReact: ((String?) -> Void)?
    init(view: UIView, btn: UIButton) {
        self.view = view
        self.btn = btn
    }
    
    private var selectedTag = 0
    
   private var iconContainerView: UIView = {
        let container  = UIView()
        container.backgroundColor = .white
        
        let padding: CGFloat = 8
        let iconHight: CGFloat = 30
        
        let imges = [#imageLiteral(resourceName: "emoji"),#imageLiteral(resourceName: "emoji"),#imageLiteral(resourceName: "emoji"),#imageLiteral(resourceName: "emoji"),#imageLiteral(resourceName: "emoji"), #imageLiteral(resourceName: "emoji")]
        var count = 0
        let arrengedSubViews = imges.map({ (image) -> UIView in
            let img = UIImageView(image: image, highlightedImage: nil)
            img.layer.cornerRadius = iconHight / 2
            img.isUserInteractionEnabled = true
            img.tag = count
            count = count + 1
            return img
        })
        
        let stackV = UIStackView(arrangedSubviews: arrengedSubViews)
        stackV.distribution = .fillEqually
        stackV.spacing = padding
        stackV.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackV.isLayoutMarginsRelativeArrangement = true
        
        container.addSubview(stackV)
        
        let numOfIcons = CGFloat(arrengedSubViews.count)
        let width = numOfIcons * iconHight + (numOfIcons + 1) * padding
        
        container.frame = CGRect(x: 0, y: 0, width: width, height: iconHight + 2 * padding)
        container.layer.cornerRadius = container.frame.height / 2
        
        // Container Shadow
        container.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackV.frame = container.frame
        
        return container
    }()

}
extension ViewLike {
    
     func setUpLongPressGeasture() {
        btn.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {

            self.didSelectReact?(Helper.getNameReact(tag: selectedTag))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (img) in
                    img.transform = .identity
                })
                
                self.iconContainerView.transform = self.iconContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconContainerView.alpha = 0
            }, completion: { (_) in
                self.iconContainerView.removeFromSuperview()
            })
            
        }
        else if gesture.state == .changed {
            handleGestureChange(gesture: gesture)
        }
        
    }
    
    fileprivate func handleGestureChange(gesture: UILongPressGestureRecognizer) {
        let pressedLoction = gesture.location(in: self.iconContainerView)
        let fixedYLocation = CGPoint(x: pressedLoction.x, y: self.iconContainerView.frame.height / 2)
        
        let hitTest = iconContainerView.hitTest(fixedYLocation, with: nil)
        if hitTest is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (img) in
                    img.transform = .identity
                })
                self.selectedTag = hitTest?.tag ?? 0
                hitTest?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        
        view.addSubview(iconContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        //        print(pressedLocation)
        let centeredX = (view.frame.width - iconContainerView.frame.width) / 2
        
        
        // alfa to 0
        iconContainerView.alpha = 0
        self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            // alfa to 1
            self.iconContainerView.alpha = 1
            
            // Transform the icon container
            self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconContainerView.frame.height)
        })
    }
}
