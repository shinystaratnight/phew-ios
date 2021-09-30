//
//  BaseViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import AVKit
class BaseViewController: UIViewController, BaseViewProtocol {
    
    lazy var repo = Repository(view: self)
    
    var profileButton: UIButton = UIButton(type: .custom)
        .withImage(UIImage(named: "avatar")!)
        .withSize(.init(all: 30)) as! UIButton
        
    let searchButton: UIButton = UIButton(type: .system)
        .withImage(#imageLiteral(resourceName: "Group 1382"))
        .withSize(.init(all: 20)) as! UIButton
    
    let settingsButton: UIButton = UIButton(type: .system)
        .withImage(#imageLiteral(resourceName: "Group 522"))
        .withSize(.init(all: 20)) as! UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cairo-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.mainWhite]
        
        startObserving(&UserInterfaceStyleManager.shared)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
     func setLogoNav() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainWhite
        imageView.image = UIImage(named: "logoWhite")
        navigationItem.titleView = imageView
    }
    
     func setButonsNav(){
//        profileButton.load(with: AuthService.userData?.profileImage)
        navigationItem.rightBarButtonItem = .init(customView: profileButton)
        navigationItem.leftBarButtonItems = [.init(customView: settingsButton), .init(customView: UIView()), .init(customView: searchButton)]
        
        // Settings Button Action
        profileButton.addTarget(self, action: #selector(profileBtnTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingBtnTapped), for: .touchUpInside)
    }
    @objc func profileBtnTapped() {
        guard let id = AuthService.userData?.id else {return}
        let vc = ShowUserProfileViewController(userId: id)
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    @objc func searchBtnTapped() {
        push(SearchViewController())
    }
    @objc func settingBtnTapped() {
        let vc = SettingViewController()
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func configView() {
        
    }
    
    deinit {
        removeNotificationsObservers()
    }
    
    func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
            
        let startDate = Date()
            
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(nil, nil)
            return
        }
            
        //Creating temp path to save the converted video
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")
            
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completionHandler?(nil, error)
            }
        }
            
        exportSession.outputURL = filePath
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
            
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(nil, exportSession.error)
            case .cancelled:
                print("Export canceled")
                completionHandler?(nil, nil)
            case .completed:
                //Video conversion finished
                let endDate = Date()
                    
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession.outputURL ?? "NO OUTPUT URL")
                completionHandler?(exportSession.outputURL, nil)
                    
                default: break
            }
                
        })
    }
}
