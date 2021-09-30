//
//  TextPostViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class PostNormalViewController: BaseViewController,UITextViewDelegate {
    
    @IBOutlet weak var btnLocationOutlet: UIButton!
    @IBOutlet weak var avatar: CircleImageView!
    @IBOutlet weak var btnFaceBooksoutlet: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    private var uploadData: [UploadData] = []
    private var privacy = "all"
    weak var deleget: AddNewPostProtocol?
    
    @IBOutlet weak var btnPostOutlet: UIButton!
    private var postId:Int?
    private var isFindaly = false
    init(postId:Int?) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isActiveButtonPost(false)
        textView.delegate = self
        updateView()
        iniCollectionView()
    }
    
    
    private var videoUrl:URL! {
        didSet{
            uploadData.append(.init(url: videoUrl, name: "videos[]"))
        }
    }
    
    private var arrMedia:[AddPostNormalModel] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionViewImages.reloadData()
                if self.arrMedia.count > 0 || self.isPostContainText(text: self.textView.text) {
                    self.isActiveButtonPost(true)
                }else{
                    self.isActiveButtonPost(false)
                }
            }
        }
    }
    
    private
    func updateView() {
        clearNavigationBackButtonTitle()
        setNavBarColor()
        hideKeyboard()
        title = "Create Post".localize
        let placeHoleder = "What's on your mind?".localize as NSString
        textView.placeholder = placeHoleder
        textView.font = .CairoRegular(of: 15)
        userName
            .withFont(.CairoSemiBold(of: 15))
        avatar.load(with: AuthService.userData?.profileImage)
        userName.text = AuthService.userData?.fullname
        
        if postId != nil {
            btnFaceBooksoutlet.isHidden = true
            btnLocationOutlet.isHidden = true
        }
    }
    
    
    @IBAction func btnFindalyTapped(_ sender: Any) {
        isFindaly.toggle()
        print(isFindaly)
        let color: UIColor = isFindaly ? .red : .lightGray
        btnFaceBooksoutlet.imageView?.tintColor = color
    }
    @IBAction func postBtnTapped(_ sender: Any) {
        
        if let postId = postId {
            repo.upload(PostModel.self, CoreRouter.shareWithComment(postId: postId, text: textView.text), data: uploadData) { [weak self](_) in
                self?.deleget?.didAddNewPost()
                self?.dismissMePlease()
            }
        }else{
            let findaly = isFindaly ? 1 : 0
            repo.upload(PostModel.self, CoreRouter.postNormal(text: textView.text, isFindaly: findaly, privacy: privacy), data: uploadData) { [weak self](_) in
                self?.deleget?.didAddNewPost()
                self?.dismissMePlease()
            }
        }
    }
    
    @IBAction func btnLocationPost(_ sender: Any) {
        push(ListGooglePlacesViewController())
    }
    @IBAction func privacyBtnTapped(_ sender: Any) {
        let vc = PrivacyPostViewController()
        vc.delegate = self
        customPresent(vc)
    }
    
    @IBAction func btnPicImageTapped(_ sender: Any) {
        PhotoServices.shared.pickImageFromGalary(on: self) { [weak self] (image) in
            if let image = image as? UIImage {
                self?.uploadData.append(.init(image: image, name: "images[]"))
                self?.arrMedia.append(.init(image: image, type: .image))
            }else {
                guard let videoUrl = image as? URL else {return}
                self?.encodeVideo(at: videoUrl) { [weak self](_url, _error) in
                    guard let url = _url else{return}
                    self?.videoUrl = url
                    self?.arrMedia.append(.init(image: nil, type: .video))
                }
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if isPostContainText(text: textView.text) || arrMedia.count > 0{
            isActiveButtonPost(true)
        }else{
            isActiveButtonPost(false)
        }
    }
    private func isPostContainText(text: String) -> Bool {
        let value = text.trimmedString
        return !value.isEmpty
    }
    
    private func isActiveButtonPost(_ active:Bool) {
        if active {
            btnPostOutlet.backgroundColor = UIColor.red
            btnPostOutlet.isEnabled  = true
        }else{
            btnPostOutlet.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            btnPostOutlet.isEnabled  = false
        }
    }
}

extension PostNormalViewController :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func iniCollectionView(){
        collectionViewImages.delegate = self
        collectionViewImages.dataSource  = self
        collectionViewImages.register(UINib(nibName: "AddPostImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"AddPostImageCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewImages.dequeueReusableCell(withReuseIdentifier: "AddPostImageCollectionViewCell", for: indexPath) as! AddPostImageCollectionViewCell
        cell.delegte = self
        cell.item = arrMedia[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
}

extension PostNormalViewController: PrivacyPostViewDelegate {
    
    func friendOlnyTapped() {
        privacy = "friends"
    }
    
    func allTapped() {
        privacy = "all"
    }
}

extension PostNormalViewController:AddPostImageCollectionViewCellProtocol{
    func deleteCell<T>(cell: T) where T : UICollectionViewCell {
        guard let index =  collectionViewImages.indexPath(for: cell) else{return}
        arrMedia.remove(at: index.row)
        uploadData.remove(at: index.row)
    }
}
