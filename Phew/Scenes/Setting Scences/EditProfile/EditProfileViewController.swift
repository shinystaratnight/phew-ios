//
//  EditProfileViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/27/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

// password ???

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var circleBtnView: UIView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    private var arrProfileImages: [AddPostNormalModel] = [] {
        didSet {
            collectionViewImages.reloadData()
        }
    }
    private var countProfileImages = 3
    private var user: User?
    private let imagePicker = PickImageVC()
    
    
    
    var userSelectedImage: UIImage? {
        didSet {
            avatar.image = userSelectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
        updateView()
        iniCollectionView()
    }
    
    private
    func updateView() {
        title = "Edit Profile".localize
        clearNavigationBackButtonTitle()
        
        hideKeyboard()
        getUserDefault()
        
        imagePicker.delegate = self
        
        userNameLbl
            .withFont(.CairoSemiBold(of: 15))
        
        userNameTxt
            .withLeadingImage(#imageLiteral(resourceName: "profilee").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .default
        
        emailTxt
            .withLeadingImage(#imageLiteral(resourceName: "mail").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .emailAddress
        
        mobileNumberTxt
            .withLeadingImage(#imageLiteral(resourceName: "myphone").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .phonePad
        
        passwordTxt
            .secure
            .withLeadingImage(#imageLiteral(resourceName: "password").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .default
    }
    
    @IBAction func changeImageBtn(_ sender: Any) {
        guard countProfileImages != arrProfileImages.count else {
            let text = "Available  images count is ".localize
            showAlert(with: "\(text) \(countProfileImages)")
            return
        }
        imagePicker.pick(sender: avatar)
    }
    
    private func getUserDefault() {
        let image    = AuthService.userData?.profileImage
        let userNmae = AuthService.userData?.fullname
        let email    = AuthService.userData?.email
        let mobile   = AuthService.userData?.mobile
        
        avatar.load(with: image)
        userNameLbl.text = userNmae
        userNameTxt.text = userNmae
        emailTxt.text    = email
        mobileNumberTxt.text = mobile
    }
    
    @IBAction func btnEditPasswordTapped(_ sender: Any) {
        push(EditPasswordViewController())
    }
    @IBAction func saveEditsBtnTapped(_ sender: Any) {
        editProfileRequest()
    }
    
    func editProfileRequest() {
        do {
            let userName = try Validator.validate(with: userNameTxt.text, decription: "User Name".localized)
            let email    = try Validator.validateMail(with: emailTxt.text)
            let mobile   = try Validator.validate(with: mobileNumberTxt.text, decription: "Mobile Number".localized)
            
            // avatar
            let parameters = [
                "_method":"PUT",
                "fullname": userName,
                "mobile": mobile,
                "email": email,
            ]
                
            let images = arrProfileImages.filter({$0.id == nil})
                .map({UploadData(image: $0.image ?? #imageLiteral(resourceName: "person"), name: "avatar[]")})
            
                repo.upload(BaseModelWith<UserData>.self, ProfileRouter.updateProfile(parameters: parameters), data: images) {[weak self] (data) in
                    guard let self = self else {return}
                    if let data = data {
                        if data.status == "true" , let userData = data.data {
                            // success
                            AuthService.userData = userData
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
            }
        } catch let error as ValidatorError {
            showAlert(with: error.associatedMessage)
        } catch { }
    }
}

extension EditProfileViewController: PickerImageDelegate, AddPostImageCollectionViewCellProtocol {
    func deleteCell<T>(cell: T) where T : UICollectionViewCell {
        guard let index = collectionViewImages.indexPath(for: cell)?.row else {return}
        if let id = arrProfileImages[index].id {
            deleteSelectedImage(image: id)
        }
        arrProfileImages.remove(at: index)
    }
    
    func didPickedImage(image: UIImage, asset: String, tag: Int) {
        arrProfileImages.append(AddPostNormalModel(image: image, type: .image))
    }
}


extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func iniCollectionView() {
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.register(UINib(nibName: "AddPostImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPostImageCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProfileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostImageCollectionViewCell", for: indexPath) as! AddPostImageCollectionViewCell
        cell.item = arrProfileImages[indexPath.row]
        cell.delegte = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
}

extension EditProfileViewController {
    private func deleteSelectedImage(image id: Int) {
        repo.request(BaseModel.self, ProfileRouter.deleteSelectedImageProfile(id: id)) { (_) in
        }
    }
    private func fetchUserProfile() {
        guard let id = AuthService.userData?.id else {return}
        repo.request(BaseModelWith<User>.self, ProfileRouter.profile(id: id)) { [weak self](response) in
            guard let data = response?.data else{return}
            self?.user = data
            self?.countProfileImages = (data.isSubscribed ?? false) ? 5 : 3
            data.profileImages?.forEach({
                self?.convertUrlToImage(imageUrl: $0.image ?? "", id: $0.id)
            })
        }
    }
    
    private func convertUrlToImage (imageUrl: String, id: Int?) {
        startLoading()
        DispatchQueue.global(qos: .background).async {
            do{
                let data = try Data.init(contentsOf: URL.init(string: imageUrl)!)
                    DispatchQueue.main.async {
                        let image: UIImage? = UIImage(data: data)
                        self.arrProfileImages.append(AddPostNormalModel(image: image, type: .image, id: id))
                        self.stopLoading()
                    }
                 }
            catch {
            }
        }
    }
}
