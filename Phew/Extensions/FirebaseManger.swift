//
//  FirebaseManger.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import FirebaseMessaging

struct FirebaseMessagingManger {
    
    static var firebaseMessagingToken: String {
        return Messaging.messaging().fcmToken ?? "Not Available"
        // return "Not Available"
    }
}
