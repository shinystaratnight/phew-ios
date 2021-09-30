//
//  PostSliderViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/9/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit


class PostSliderViewController: UIViewController {
    
    @IBOutlet weak var collectionViewHeigt: NSLayoutConstraint!
    @IBOutlet weak var collectionViewPost: UICollectionView!
    private var arrPosts = [HomePostNormalViewModel]()
    
    init(arrPosts:[HomePostNormalViewModel]) {
        self.arrPosts = arrPosts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor.black.withAlphaComponent(0.9)
        view.backgroundColor = color
        iniCollectionView()
        
        if arrPosts.count == 1 {
            collectionViewHeigt.constant = 100
        }else {
            collectionViewHeigt.constant = 20
        }
        
    }
    
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        dismissMePlease()
    }
    
    
}
//ImageNormalPostCollectionViewCell

extension PostSliderViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func iniCollectionView(){
        collectionViewPost.delegate = self
        collectionViewPost.dataSource = self
        collectionViewPost.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewPost.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
        cell.item = arrPosts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 300
        if arrPosts.count == 1 {
            height = 400
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arrPosts[indexPath.row].type == .video{
            let url = arrPosts[indexPath.row].url!
            
            let vc = PalyVideoViewController(vedioUrl:url)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        }
        
    }
}
