//
//  HomeTabBarViewController.swift
//  Phew
//func didSelectImagesCell(cell: MainPostTableViewCell) {
//
//}
//customPresent(vc)
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import JJFloatingActionButton


enum PostType {
    case friends
    case global
}
protocol AddNewPostProtocol : AnyObject{
    func didAddNewPost()
}

class HomeTabBarViewController: BaseViewController {
    @IBOutlet weak var viewContainer: UIView!
    private var postType = PostType.global
    fileprivate let actionButton = JJFloatingActionButton()

    private var customeVC = CustomeViewController(user: nil, type: .home)
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupFloatingActionButton()
        setView()
        setLogoNav()
        setButonsNav()
        addCustomeVC()
    }
    
    func setupFloatingActionButton() {
        actionButton.itemAnimationConfiguration   = .circularSlideIn(withRadius: 120)
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: .pi * 3 / 4)
        actionButton.buttonAnimationConfiguration.opening.duration = 0.8
        actionButton.buttonAnimationConfiguration.closing.duration = 0.6
        actionButton.buttonColor = .red
        
        actionButton.buttonDiameter = 60
        actionButton.itemAnimationConfiguration = .circularPopUp()
        
        actionButton.addItem(image: UIImage(named: "location")) { item in
            let vc = ListGooglePlacesViewController()
            vc.deleget = self
            self.present(vc.toNavigation, animated: true, completion: nil)
        }
        
        actionButton.addItem(image: UIImage(named: "watching")) { item in
            let vc = ListFilmsViewController()
            vc.deleget = self
            self.present(vc.toNavigation, animated: true, completion: nil)
        }
        
        actionButton.addItem(image: UIImage(named: "quote")) { item in
            let vc = PostNormalViewController(postId: nil)
            vc.deleget = self
            self.present(vc.toNavigation, animated: true, completion: nil)
        }
//        actionButton.withSize(CGSize(width: 60, height: 60))
        actionButton.display(inViewController: self)
    }

    private func addCustomeVC() {
        addChildViewController(childViewController: customeVC, childViewControllerContainer: viewContainer)
    }
}

extension HomeTabBarViewController {
    private func setView(){
        navigationItem.rightBarButtonItem = .init(customView: profileButton)
        navigationItem.leftBarButtonItems = [.init(customView: settingsButton), .init(customView: searchButton)]
        setImageTitle()
        setLogoNav()
    }
}

extension HomeTabBarViewController: AddNewPostProtocol{
    func didAddNewPost() {
        customeVC.featchHome = true
    }
}
