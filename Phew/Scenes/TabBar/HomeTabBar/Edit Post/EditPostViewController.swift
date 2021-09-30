//
//  EditPostViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/24/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class EditPostViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var btnPostOutlet: UIButton!
    @IBOutlet weak var txtPost: RSKPlaceholderTextView!
    private var postId: Int
    private var text: String
    
    init(postId: Int, text: String) {
        self.postId = postId
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        removeNotificationsObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPost.text = text
        txtPost.delegate = self
    }
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
        updatePost()
        
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if isPostContainText(text: textView.text)  {
            self.isActiveButtonPost(true)
        }else{
            self.isActiveButtonPost(false)
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

extension EditPostViewController {
    private func updatePost() {
        repo.request(BaseModel.self, CoreRouter.updatePost(id: postId, text: txtPost.text)) { [weak self](_) in
            NotificationCenter.default.post(name: .reloadHomeData, object: nil)
            self?.dismissMePlease()
        }
    }
}
