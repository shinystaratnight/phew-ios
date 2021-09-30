//
//  ReplySecretMessageViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/26/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class ReplySecretMessageViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var btnSendOutlet: UIButton!
    @IBOutlet weak var txtReply: RSKPlaceholderTextView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    

    private var uploadData: [UploadData] = []
    private var message: SectertMessages
    
    init(message: SectertMessages) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var videoUrl:URL! {
        didSet{
            uploadData.append(.init(url: videoUrl, name: "videos[]"))
        }
    }
    private var arrMedia:[AddPostNormalModel] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.arrMedia.count > 0 || self.isPostContainText(text: self.txtReply.text) {
                    self.isActiveButtonPost(true)
                }else{
                    self.isActiveButtonPost(false)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtReply.placeholder = "Enter Reply for this message".localize as NSString
        lblMessage.text = message.message
        
        iniCollectionView()
        isActiveButtonPost(false)
        txtReply.delegate = self
    }
    private func isPostContainText(text: String) -> Bool {
        let value = text.trimmedString
        return !value.isEmpty
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        guard let id = message.id else {return}
        repo.upload(PostModel.self, SecretMessageRouter.reply(text: txtReply.text, messageId: id), data: uploadData) { [weak self](_) in
//            self?.deleget?.didAddNewPost()
            self?.popMe()
        }
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
    
    @IBAction func btnPolicypostTapped(_ sender: Any) {
        let vc = PrivacyPostViewController()
        vc.delegate = self
        customPresent(vc)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if isPostContainText(text: textView.text) || arrMedia.count > 0{
            isActiveButtonPost(true)
        }else{
            isActiveButtonPost(false)
        }
    }
    private func isActiveButtonPost(_ active:Bool) {
        if active {
            btnSendOutlet.backgroundColor = UIColor.red
            btnSendOutlet.isEnabled  = true
        }else{
            btnSendOutlet.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            btnSendOutlet.isEnabled  = false
        }
    }
}

extension ReplySecretMessageViewController :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func iniCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.register(UINib(nibName: "AddPostImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"AddPostImageCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostImageCollectionViewCell", for: indexPath) as! AddPostImageCollectionViewCell
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

extension ReplySecretMessageViewController: PrivacyPostViewDelegate {
    
    func friendOlnyTapped() {
        print("friend")
    }
    
    func allTapped() {
        print("all")
    }
}
extension ReplySecretMessageViewController: AddPostImageCollectionViewCellProtocol{
    func deleteCell<T>(cell: T) where T : UICollectionViewCell {
        guard let index =  collectionView.indexPath(for: cell) else{return}
        arrMedia.remove(at: index.row)
        uploadData.remove(at: index.row)
    }
}
