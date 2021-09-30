//
//  LocalStorage.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/28/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation


import Foundation
class AudioUrlCach {
    static var shared = AudioUrlCach()
    
    private var cachedData: [String: String]?
    
    func getCachedFileURl(key: String , compleation: @escaping ((_ data: String?) -> Void)) {
        LocalStorageManger.shared.feachDataFromCache([String: String].self, key: .event) { data in
            guard data != nil else {return compleation(nil)}
            DispatchQueue.main.async {
                
                var localUrl: String?
              let _ =  data?.filter({ (_key, value) -> Bool in
                if _key.contains(key) {
                        localUrl = value
                    }
                    return true
                })
                compleation(localUrl)
                
            }
        }
    }
    func getAllURL() {
        LocalStorageManger.shared.feachDataFromCache([String: String].self, key: .event) { (data) in
            print(data as Any)
            print(data?.count as Any)
        }
    }
    
    func addAudioURLToCash(key: String, url: String, compleation: @escaping (() -> Void)) {
        if cachedData == nil {
            cachedData = [:]
        }
        cachedData?[key] = url
        LocalStorageManger.shared.cache(cachedData, key: .event) {
            DispatchQueue.main.async {
                compleation()
            }
        }
    }
    
    func deleteCash(compleation: @escaping (() -> Void)) {
        cachedData?.removeAll()
        LocalStorageManger.shared.cache(cachedData, key: .event) {
            DispatchQueue.main.async {
                compleation()
            }
        }
    }
}
