//
//  ChatViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/23/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ChatViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnAudioConstrain: NSLayoutConstraint!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var btnArrowOutlet: UIButton!
    @IBOutlet weak var btnAudioOutlet: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tableviewChat: UITableView!
    
    private var soundRecord: AVAudioRecorder!
    private var soundPlayer: AVAudioPlayer?
    private var fileName =  ""
    private var arrOldChats = [ChatViewModel]()
    
    private var messageId: Int
    
    init(messageId: Int) {
        self.messageId = messageId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setImageArrowArabic()
        initTableview()
        feachOldMessages()
        btnDeleteOutlet.isHidden = true
        clearNavigationBackButtonTitle()
        fileName = "audio\(Helper.randomString(length: 5)).m4a"
        recordSetting()
        soundPlayer?.delegate = self
        
        SocketEcho.shared.connect()
        SocketEcho.shared.deleget = self
        SocketEcho.shared.chat(chatId: messageId)
        addDoneButtonKeyboard()
    }
    private var isRecord: Bool = false {
        didSet{
            if isRecord {
                txtMessage.isHidden = true
                btnDeleteOutlet.isHidden = false
                startAnumation()
            }else{
                txtMessage.isHidden = false
                btnAudioOutlet.imageView?.tintColor = .lightGray
                btnAudioOutlet.layer.removeAllAnimations()
                btnDeleteOutlet.isHidden = true
            }
        }
    }
    
    @IBAction func btnSendMessageTapped(_ sender: Any) {
        if isRecord {
            isRecord.toggle()
            soundRecord.stop()
            sendAudioMessage()
        }else{
            sendText()
        }
    }
    @IBAction func btnRecordTapped(_ sender: Any) {
        isRecord.toggle()
        if isRecord {
            soundRecord.record()
            print("Start")
        }else {
            soundRecord.stop()
            print("stop")
        }
    }
    
    @IBAction func btnImageTapped(_ sender: Any) {
        PhotoServices.shared.pickImageFromGalary(on: self) { [weak self](image) in
            guard let _image = image as? UIImage else {return}
            self?.sendImageMessage(image: _image)
        }
    }
    @IBAction func btnDeleteTapped(_ sender: Any) {
        soundRecord.deleteRecording()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            
            self.btnAudioConstrain.constant = 100
            self.btnAudioOutlet.transform = CGAffineTransform(rotationAngle:  -0.999*CGFloat.pi)
        } completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.btnAudioConstrain.constant = -33
                self.isRecord.toggle()
            } completion: {  (_) in
                self.btnAudioOutlet.transform = .identity
            }
        }
    }
    
    private func setImageArrowArabic() {
        if AuthService.isArabic {
            btnArrowOutlet.setImage(#imageLiteral(resourceName: "arrow-pointing-to-right-1"), for: .normal)
        }
    }
    private func startAnumation() {
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.5
        scaleAnimation.repeatCount = Float.infinity
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.8
        btnAudioOutlet.imageView?.tintColor = .red
        self.btnAudioOutlet.layer.add(scaleAnimation, forKey: "scale")
    }
    private func addDoneButtonKeyboard() {
        txtMessage.delegate = self
        txtMessage.returnKeyType = .send
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendText()
        return true
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func initTableview() {
        tableviewChat.keyboardDismissMode = .onDrag
        tableviewChat.delegate = self
        tableviewChat.dataSource = self
//        tableviewChat.rowHeight = 60
        tableviewChat.register(ChatTextTableViewCell.self, forCellReuseIdentifier: "ChatTextTableViewCell")
        tableviewChat.registerCellNib(cellClass: AudioTableViewCell.self)
        tableviewChat.register(ChatImageTableViewCell.self, forCellReuseIdentifier: "ChatImageTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOldChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = arrOldChats[indexPath.row].messageType
        switch type {
        case .text:
            let cell = tableviewChat.dequeueReusableCell(withIdentifier: "ChatTextTableViewCell", for: indexPath) as! ChatTextTableViewCell
            cell.item = arrOldChats[indexPath.row]
            return cell
        case .audio:
            let cell = tableviewChat.dequeueReusableCell(withIdentifier: "AudioTableViewCell", for: indexPath) as! AudioTableViewCell
            cell.deleget = self
            cell.item = arrOldChats[indexPath.row]
            return cell
        case .image:
            let cell = tableviewChat.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell", for: indexPath) as! ChatImageTableViewCell
            cell.item = arrOldChats[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = arrOldChats[indexPath.row].messageType
        
        switch type {
        case .text:
            return  UITableView.automaticDimension
        case .audio:
            return 60
        case .image:
            return 130
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = arrOldChats[indexPath.row].messageType
        
        switch type {
        case .text:
            return  UITableView.automaticDimension
        case .audio:
            return 60
        case .image:
            return 130
        }
    }
}

extension ChatViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    private func recordSetting() {
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
                            AVSampleRateKey: 44100.0,
                            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        do {
            soundRecord = try AVAudioRecorder(url: getFileUrl(), settings: recordSettings)
            soundRecord.delegate = self
            soundRecord.prepareToRecord()
        }catch {
            print(error)
        }
    }
    private func getCacheDirectory() -> String {
        let paths  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    private func getFileUrl() -> URL {
        let path = getCacheDirectory().stringByAppendingPathComponent(path: fileName)
        let filePath = URL(fileURLWithPath: path)
        return filePath
    }
}
extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}

extension ChatViewController: AudioTableViewCellProtocol {
    func playAudioTapped(cell: AudioTableViewCell) {

        guard let index = tableviewChat.indexPath(for: cell) else {return}
        guard let videoUrl = arrOldChats[index.row].message else {return}
        
        if arrOldChats[index.row].isPlayAudio {
            arrOldChats[index.row].isPlayAudio = false
            arrOldChats[index.row].isDownloadNow = false
            soundPlayer?.stop()
            tableviewChat.reloadRows(at: [index], with: .none)
        } else {
            resetArray()
            arrOldChats[index.row].isDownloadNow = true
            tableviewChat.reloadData()
            AudioUrlCach.shared.getCachedFileURl(key: videoUrl) { [weak self] (locaURL) in
                if  locaURL != nil {
                    print("Cash")
                    self?.reloadCellAfterDwnloadFile(index: index, localUrl: locaURL)
                }else {
                    print("remote")
                    self?.downloadFile(index: index, videoUrl: videoUrl)
                }
            }
        }
    }
    private func preparePlayer(fileName: String) -> Float {
        do{
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            print(documentsURL)
            soundPlayer = try AVAudioPlayer(contentsOf: documentsURL)
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
            soundPlayer?.play()
            let duration = Float(soundPlayer?.duration ?? 0.0)
            return duration
        }catch {
            return 0.0
        }
    }
    
    private func downloadFile(index: IndexPath, videoUrl: String) {
        repo.downloadFile(url: videoUrl) { [weak self](localUrl) in
            guard let self = self else {return}
            guard let _urlLocal = localUrl else {return}
            AudioUrlCach.shared.addAudioURLToCash(key: videoUrl, url: _urlLocal) {
                DispatchQueue.main.async {
                    self.reloadCellAfterDwnloadFile(index: index, localUrl: localUrl)
                }
            }
        }
    }
    
    private func reloadCellAfterDwnloadFile(index: IndexPath, localUrl: String?) {
        resetArray()
        self.arrOldChats[index.row].isDownloadNow = false
        self.arrOldChats[index.row].isPlayAudio = true
        self.arrOldChats[index.row].audioLocalUrl = localUrl
        let duration =  preparePlayer(fileName: localUrl ?? "")
        arrOldChats[index.row].durationTime = duration +  1.0
        tableviewChat.reloadData()
    }
    
    private func resetArray() {
        for index in arrOldChats.indices {
            arrOldChats[index].isPlayAudio = false
            arrOldChats[index].durationTime = 0.0
        }
    }
}

extension ChatViewController {
    func sendAudioMessage() {
        repo.upload(BaseModelWith<ChatModel>.self, ChatRouter.send(id: messageId, parameters: ["message_type": "voice_message"]), data: [UploadData(url: getFileUrl(), name: "message")]) { [weak self](response) in
            guard let self = self else {return}
            guard let chat = response?.data else {return}
            self.addRow(chat: chat)
        }
    }
    
    func sendText(){
        guard let text = txtMessage.text, text.count > 0 else {return}
        repo.request(BaseModelWith<ChatModel>.self, ChatRouter.send(id: messageId, parameters: ["message_type": "text", "message": text])) { [weak self](response) in
            guard let self = self else {return}
            guard let chat = response?.data else {return}
            self.addRow(chat: chat)
        }
    }
    
    func sendImageMessage(image: UIImage) {
        repo.upload(BaseModelWith<ChatModel>.self, ChatRouter.send(id: messageId, parameters: ["message_type": "image"]), data: [UploadData(image: image, name: "message")]) {[weak self] (response) in
            guard let self = self else {return}
            guard let chat = response?.data else {return}
            self.addRow(chat: chat)
        }
    }
    
    private func feachOldMessages() {
        repo.request(BaseModelWith<[ChatModel]>.self, ChatRouter.show(id: messageId)) { [weak self] (response) in
            guard let self = self else {return}
            guard let arrChats = response?.data else {return}
            let arrChat = self.getChatViewModel(chats: arrChats)
            self.arrOldChats = arrChat
            self.arrOldChats.reverse()
            self.tableviewChat.reloadData()
            self.tableviewChat.scrollToBottom()
        }
    }
    private func addRow(chat: ChatModel){
        let chat = self.getChatViewModel(chats: [chat])
        arrOldChats.append(contentsOf: chat)
        handelTableView()
    }
    private func handelTableView(){
        let index = IndexPath(row: arrOldChats.count - 1, section: 0)
        tableviewChat.beginUpdates()
        tableviewChat.insertRows(at: [index], with: .automatic)
        tableviewChat.endUpdates()
        tableviewChat.scrollToBottom()
        txtMessage.text = nil
    }
    
    private func getChatViewModel(chats: [ChatModel]) -> [ChatViewModel] {
        var arr: [ChatViewModel] = []
        var userType = UserTypeEnum.me
        var messageType = MessageTypeEnum.image
        chats.forEach({
            // check position
            if let _userType = $0.messagePosition, _userType == "current" {
                userType = .me
            } else {
                userType = .you
            }
            //check message tyep
            let _messageType = $0.messageType ?? ""
            if _messageType == "text" {
                messageType = .text
            }else if _messageType == "image" {
                messageType = .image
            }else{
                messageType = .audio
            }
            arr.append(ChatViewModel(userType: userType, messageType: messageType, message: $0.message, avatar: $0.senderData?.profileImage, date: $0.createdAt ,isPlayAudio: false, isDownloadNow: false))
        })
        return arr
    }
}

extension ChatViewController {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        soundPlayer?.stop()
        for index in arrOldChats.indices {
            arrOldChats[index].isPlayAudio = false
            arrOldChats[index].durationTime = 0.0
        }
        tableviewChat.reloadData()
    }
}

extension ChatViewController: SocketEchoProtocol {
    func newMessage(chat: ChatModel?) {
        guard var _chat = chat else{return}
        
        guard let senderId = _chat.senderData?.id,
              let myId = AuthService.userData?.id
        else { return }
        if senderId != myId {
            _chat.messagePosition = "other"
            addRow(chat: _chat)
            // _chat.messagePosition = "me"
        }
    }
}
