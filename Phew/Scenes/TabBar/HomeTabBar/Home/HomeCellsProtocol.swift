//
//  HomeCellsProtocol.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/15/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//NSLayoutYAxisAnchor

import Foundation
import UIKit
  protocol HomeCellsProtocol:AnyObject{
    func didTappedUserImage<T:UITableViewCell>(cell:T)
    func didTappedUserImageReplay<T:UITableViewCell>(cell:T)
    
    func didTappedLike<T:UITableViewCell>(cell:T)
    func didTappedWashlist<T:UITableViewCell>(cell:T)
    func didTappedShare<T:UITableViewCell>(cell:T)
    func didTappedComment<T:UITableViewCell>(cell:T)
    
    func didTappedFirstFrinds<T:UITableViewCell>(cell:T)
    func didTappedAllFrinds<T:UITableViewCell>(cell:T)
    
    func didTappedFirstFrindsReplay<T:UITableViewCell>(cell:T)
    func didTappedAllFrindsReplay<T:UITableViewCell>(cell:T)
    func didTappedRact(reactType: String, postId: Int)
    func didTappedShowUserTakeScreens(postId: Int)
    
    // media
    func didSelectMedia<T:UITableViewCell>(cell:T)
    func didSelectMediaRplay<T:UITableViewCell>(cell:T)
    
    func didTappedOwnerEditPost(postId: Int, topAnchor: NSLayoutYAxisAnchor)
    // show post
    func didTappedShowPost<T:UITableViewCell>(cell:T)
    func didTappedShowReplay<T:UITableViewCell>(cell:T)
    
    func didTappedDeleteAdv<T:UITableViewCell>(cell:T)
}
extension HomeCellsProtocol{
    func didTappedUserImage<T:UITableViewCell>(cell:T){}
    func didTappedUserImageReplay<T:UITableViewCell>(cell:T){}
    
    func didTappedLike<T:UITableViewCell>(cell:T){}
    func didTappedWashlist<T:UITableViewCell>(cell:T){}
    func didTappedShare<T:UITableViewCell>(cell:T){}
    func didTappedComment<T:UITableViewCell>(cell:T){}
    
    func didTappedFirstFrinds<T:UITableViewCell>(cell:T){}
    func didTappedAllFrinds<T:UITableViewCell>(cell:T){}
    
    func didTappedFirstFrindsReplay<T:UITableViewCell>(cell:T){}
    func didTappedAllFrindsReplay<T:UITableViewCell>(cell:T){}
    
//    func didPost<T:UITableViewCell>(cell:T)
//    func didPostReplay<T:UITableViewCell>(cell:T)
    
    // media
    func didSelectMedia<T:UITableViewCell>(cell:T){}
    func didSelectMediaRplay<T:UITableViewCell>(cell:T){}
    
    // show post
    func didTappedShowPost<T:UITableViewCell>(cell:T){}
    func didTappedShowReplay<T:UITableViewCell>(cell:T){}
    func didTappedRact(reactType: String, postId: Int){}
    func didTappedShowUserTakeScreens(postId: Int){}
    func didTappedOwnerEditPost(postId: Int, topAnchor: NSLayoutYAxisAnchor){}
    func didTappedDeleteAdv<T:UITableViewCell>(cell:T){}
}
