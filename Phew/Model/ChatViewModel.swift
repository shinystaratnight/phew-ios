//
//  ChatViewModel.swift
//  Caberz
//
//  Created by Ahmed Elesawy on 12/10/20.
//

import Foundation

enum UserTypeEnum {
    case me
    case you
}

enum MessageTypeEnum {
    case text
    case audio
    case image
    
    var name: String {
        switch self {
        case .text:
            return "text"
        case .audio:
            return "voice_message"
        case .image:
            return "image"
        }
    }
}

struct ChatViewModel {
    var userType: UserTypeEnum
    var messageType: MessageTypeEnum
    var message: String?
    var avatar: String?
    var date: String?
    var isPlayAudio: Bool
    var isDownloadNow: Bool
    var audioLocalUrl: String?
    var durationTime: Float?
}
