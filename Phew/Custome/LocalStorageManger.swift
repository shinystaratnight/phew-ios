//
//  LocalStorageManger.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/28/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//


import Cache
import Foundation

class LocalStorageManger: NSObject {
    
    private let _DiskConfigKey = "AppCache"

    private let maxSize: UInt = UInt(900_000_000) // 900 MB

    static let shared = LocalStorageManger()

    private override init() {
        super.init()
    }

    private func getDiskConfig() -> DiskConfig {
        return DiskConfig(name: _DiskConfigKey)
    }

    private func getMemoryConfig() -> MemoryConfig {
        return MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
    }

    func cache<T: Codable>(_ data: T, key: CacheKeys, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let diskConfig = self.getDiskConfig()
            let memoryConfig = self.getMemoryConfig()
            do {
                let storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
                let productStorage = storage.transformCodable(ofType: T.self)
                try productStorage.setObject(data, forKey: key.rawValue)
                DispatchQueue.main.sync {
                    completion?()
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }

    func feachDataFromCache<T: Codable>(_: T.Type, key: CacheKeys, completion: @escaping ((_ data: T?) -> Void)) {
        let diskConfig = DiskConfig(name: _DiskConfigKey, expiry: .never, maxSize: maxSize, directory: nil, protectionType: FileProtectionType.none)
        let memoryConfig = getMemoryConfig()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
                let productStorage = storage.transformCodable(ofType: T.self)
                let data = try productStorage.object(forKey: key.rawValue)
                DispatchQueue.main.async {
                    completion(data)
                }
            } catch {
                completion(nil)
                debugPrint(error.localizedDescription)
            }
        }
    }

    enum CacheKeys: String {
        case event
    }
}
