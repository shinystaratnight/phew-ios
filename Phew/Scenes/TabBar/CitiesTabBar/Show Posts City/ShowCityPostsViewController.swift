//
//  ShowCityPostsViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/24/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class ShowCityPostsViewController: UIViewController {

    private var cityId: Int
    private var countryId: Int
    private var mainVC: CustomeViewController!
    
    init(cityId: Int, countryId :Int) {
        self.cityId = cityId
        self.countryId = countryId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVC = CustomeViewController(user: nil, type: .findaly(countryId: countryId, cityId: cityId))
        self.addChildViewController(childViewController: mainVC, childViewControllerContainer: view)
        
    }

}
