//
//  MultiSelectImagesViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/22/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class MultiSelectImagesViewController: UIViewController {

    @IBOutlet weak var txtCommnet: RSKPlaceholderTextView!
    @IBOutlet weak var collecionViewImages: UICollectionView!
    
    var didAddCommnet : (( _ arr : [UIImage], _ text: String)->(Void))?
    
    private var image:UIImage
    private var arrImages:[UIImage] = [] {
        didSet{
            arrImages.reverse()
            collecionViewImages.reloadData()
        }
    }
    
    init(image:UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor.black.withAlphaComponent(0.6)
        view.backgroundColor = color
        txtCommnet.placeholder = "Add Comment".localized as NSString
        iniCollectionView()
        arrImages.append(image)
      
    }
    
    
    @IBAction func btnPicImageTapped(_ sender: Any) {
        PhotoServices.shared.pickImageFromGalary(on: self) { [weak self](selectedImage) in
            if let image = selectedImage as? UIImage {
                self?.arrImages.append(image)
            }
        }
        
    }
    
    @IBAction func btnAddCommnetTapped(_ sender: Any) {
        didAddCommnet?(arrImages, txtCommnet.text)
        self.dismissMePlease()
    }
}


extension MultiSelectImagesViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func iniCollectionView(){
        collecionViewImages.delegate = self
        collecionViewImages.dataSource = self
       
        collecionViewImages.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecionViewImages.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
        cell.image = arrImages[indexPath.row]
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width / 1.2
        if arrImages.count == 1 {
            width = collectionView.frame.width
        }
       
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
