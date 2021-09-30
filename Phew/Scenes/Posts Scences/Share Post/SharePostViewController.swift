//
//  SharePostViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/19/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class SharePostViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var viewPostHeight: NSLayoutConstraint!
    @IBOutlet weak var tableviewPosts: UITableView!
    @IBOutlet weak var btnLocationOutlet: UIButton!
    @IBOutlet weak var avatar: CircleImageView!
    @IBOutlet weak var btnFaceBooksoutlet: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var btnPostOutlet: UIButton!
    
    private var post:HomeModel
    private let imagePickerController = UIImagePickerController()
    private var uploadData: [UploadData] = []
    
    weak var deleget :AddNewPostProtocol?
    
    private var postType = PostEnum.normal
    private var postId:Int
    private var cellHeight:CGFloat
    
    init(postId:Int, postType:PostEnum, post:HomeModel, cellHeight:CGFloat) {
        self.postId = postId
        self.postType = postType
        self.post = post
        self.cellHeight = cellHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        isActiveButtonPost(false)
        textView.delegate = self
        updateView()
        iniCollectionView()
        iniTableView()
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
                if self.arrMedia.count > 0 {
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
//        trasperantNavBar()
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
        
        btnFaceBooksoutlet.isHidden = true
        btnLocationOutlet.isHidden = true
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        repo.upload(PostModel.self, CoreRouter.shareWithComment(postId: postId, text: textView.text), data: uploadData) { [weak self](_) in
            self?.deleget?.didAddNewPost()
            self?.dismissMePlease()
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
    
    
    @IBAction func btnAttachVideoTapped(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnPicImageTapped(_ sender: Any) {
        PhotoServices.shared.pickImageFromGalary(on: self) { [weak self] (image) in
            if let image = image as? UIImage {
                self?.uploadData.append(.init(image: image, name: "images[]"))
                self?.arrMedia.append(.init(image: image, type: .image))
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text.isEmpty{
            isActiveButtonPost(false)
        }else{
            isActiveButtonPost(true)
        }
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

extension SharePostViewController:UITableViewDelegate, UITableViewDataSource {
    
    private func iniTableView(){
        tableviewPosts.delegate = self
        tableviewPosts.dataSource = self
        tableviewPosts.rowHeight = cellHeight
       
        switch postType{
        case .normal:
            tableviewPosts.registerCellNib(cellClass: MainPostTableViewCell.self)
            viewPostHeight.constant = cellHeight - 50
        case .location:
            tableviewPosts.registerCellNib(cellClass: LocationPostTableViewCell.self)
            viewPostHeight.constant = cellHeight
        case .watching:
            tableviewPosts.registerCellNib(cellClass: WatchingPostUItabviewCell.self)
            viewPostHeight.constant = cellHeight
        case .sharePost, .ShareText:
            break
        case .shareLocation:
            break
        case .shareWatch, .sponsor:
            break
        case .secretMessage:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch postType {
        case .normal:
            let cell = tableviewPosts.dequeueReusableCell(withIdentifier: "MainPostTableViewCell") as! MainPostTableViewCell
            cell.item = post
            cell.stackActionButtons.isHidden = true
            cell.viewLine.isHidden = true
            cell.deleget = self
            return cell
        case .location:
            let cell = tableviewPosts.dequeueReusableCell(withIdentifier: "LocationPostTableViewCell") as! LocationPostTableViewCell
            cell.item = post
            cell.btnShareOutlet.isHidden = true
            cell.btnFavOutlet.isHidden = true
            cell.delegate = self
            return cell
        case .watching:
            let cell = tableviewPosts.dequeueReusableCell(withIdentifier: "WatchingPostUItabviewCell") as! WatchingPostUItabviewCell
            cell.item = post
            cell.btnShareOutlet.isHidden  = true
            cell.btnWashListOutlet.isHidden = true
            cell.delegate = self
            return cell
        case .sharePost, .ShareText:
            return UITableViewCell()
        case .shareLocation:
            return UITableViewCell()
        case .shareWatch, .sponsor:
            return UITableViewCell()
        case .secretMessage:
            return UITableViewCell()
        }
    }
    
    
}

//AddPostImageCollectionViewCell
extension SharePostViewController :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension SharePostViewController: PrivacyPostViewDelegate {
    
    func friendOlnyTapped() {
        print("friend")
    }
    
    func allTapped() {
        print("all")
    }
}

extension SharePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            encodeVideo(at: videoUrl) { [weak self](_url, _error) in
                
                guard let url = _url else{return}
                self?.videoUrl = url
                self?.arrMedia.append(.init(image: nil, type: .video))
            }
        }
    }
}

extension SharePostViewController:AddPostImageCollectionViewCellProtocol{
    func deleteCell<T>(cell: T) where T : UICollectionViewCell {
        guard let index =  collectionViewImages.indexPath(for: cell) else{return}
        arrMedia.remove(at: index.row)
        uploadData.remove(at: index.row)
        print(arrMedia.count)
        
    }
}

extension SharePostViewController: HomeCellsProtocol{
    
    func didTappedShowPost<T>(cell: T) where T : UITableViewCell {
        
    }
    func didSelectMedia<T>(cell: T) where T : UITableViewCell {
        var arrPostNormal = [HomePostNormalViewModel]()
        arrPostNormal =  Helper.getArrayMedia(arrVideos: post.videos, arrImages: post.images)
        presentModelyVC(PostSliderViewController(arrPosts: arrPostNormal))
        
    }
}
