//
//  Network.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Alamofire

typealias NetworkCompletion<T> = (Result<T>) -> ()

protocol NetworkProtocol {
    func request<T>(_ request: URLRequestConvertible, decodeTo type: T.Type, completionHandler: @escaping NetworkCompletion<T>) where T: Codable
    func upload<T>(_ request: URLRequestConvertible, data: [UploadData], decodedTo type: T.Type, completionHandler: @escaping NetworkCompletion<T>) where T: Codable
    func cancelAllRequests()
}

class Network {
    
    fileprivate let networkMiddleware = NetworkMiddleware()
    
    //Use a networkmiddleware to append the headers globally
    fileprivate lazy var manager: SessionManager = {
        let manager = networkMiddleware.sessionManager
        manager.adapter = networkMiddleware
        manager.retrier = NetworkRequestRetrier()
        // manager.session.configuration.timeoutIntervalForRequest = 60
        return manager
    }()
    
    fileprivate func process<T>(response: DataResponse<Any>, decodedTo type: T.Type) -> Result<T> where T: Codable {
        switch response.result {
        case .success:
            
            guard let data = response.data else {
                return .failure(NSError.create(description: "Server Error.".localize))
            }
            
            #if DEBUG
            print(SwiftyJSON(response.value ?? [:]))
            #endif
            
            do {
                let data = try JSONDecoder.decodeFromData(type, data: data)
                return .success(data)
            } catch {
                
                #if DEBUG
                debugPrint(error)
                #endif
                
                return .failure(NSError.create(description: "Server Error.".localize))
            }
            
        case .failure(let error):
            
            #if DEBUG
            debugPrint("#DEBUG#", error.localizedDescription)
            #endif
            
            if error.localizedDescription.contains("JSON") {
                return .failure(NSError.create(description: "Server Error.".localize))
            }
            
            return .failure(error)
        }
    }
    
    func cancelAllRequests() {
        manager.session.getAllTasks { tasks in tasks.forEach { $0.cancel() } }
    }
}

extension Network: NetworkProtocol {
    func request<T>(_ request: URLRequestConvertible, decodeTo type: T.Type, completionHandler: @escaping (Result<T>) -> ()) where T: Codable {
        print(request.url)
        manager.request(request).debugLog().responseJSON {[weak self] response in
            guard let self = self else { return }
            completionHandler(self.process(response: response, decodedTo: type))
        }
    }
    
    func upload<T>(_ request: URLRequestConvertible, data: [UploadData], decodedTo type: T.Type, completionHandler: @escaping (Result<T>) -> ()) where T: Decodable, T: Encodable {
        
        print(SwiftyJSON(request.parameters ?? [:]))
        manager
            .upload(multipartFormData: { multipart in
                
                data.forEach {
                    if let url = $0.url {
                        multipart.append(url, withName: $0.name)
                        
                    } else if let data = $0.data {
                        multipart.append(data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
                    }
                }
                
                for (key, value) in request.parameters ?? [:] {
                    multipart.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }, with: request) { encodingCompletion in
                switch encodingCompletion {
                case .success(let request, _, _):
                    
                    request.uploadProgress(closure: { (progress) in
                        #if DEBUG
                        print(String(format: "%.1f", progress.fractionCompleted * 100))
                        #endif
                    })
                    
                    request
                        .debugLog()
                        .responseJSON {[weak self] response in
                            guard let self = self else { return }
                            completionHandler(self.process(response: response, decodedTo: type))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
        }
    }
}
