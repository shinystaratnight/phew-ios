//
//  PalyVideoViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/9/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

class PalyVideoViewController: UIViewController {
    @IBOutlet weak var viewVideo: UIView!
    
    private var url:String
    var player:AVPlayer?
    init(vedioUrl:String) {
        self.url = vedioUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        playVideo(urlVideo: url)
        // Do any additional setup after loading the view.
    }
    
    private func playVideo(urlVideo:String){
        guard let url =  URL(string:urlVideo) else{return}
         player = AVPlayer(url: url)
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        playerVC.view.backgroundColor = .clear
       addChildViewController(childViewController: playerVC, childViewControllerContainer: viewVideo)
        guard let play = player else {return}
        play.play()
    
    }

    @IBAction func btnDismissTaped(_ sender: Any) {
        if let play = player {
                    print("stopped")
                    play.pause()
                    player = nil
                    print("player deallocated")
                } else {
                    print("player was already deallocated")
                }
        
        dismissMePlease()
    }
}
