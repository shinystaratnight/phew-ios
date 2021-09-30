//
//  Repository.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

protocol RepositoryProtocol: AnyObject {
    func request<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, showLoader: Bool, completionHandler: @escaping (_ data: U?)->())
    func request<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, completionHandler: @escaping (_ data: U?)->())
    func upload<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, data: [UploadData], completionHandler: @escaping(_ data: U?)->())
    func downloadFile(url: String, completionHandler: @escaping (_ data: String?)->())
}

class Repository: RepositoryProtocol {
    
    private var network: NetworkProtocol
    private weak var view: BaseViewProtocol?
    
    init(view: BaseViewProtocol) {
        network = Network()
        self.view = view
    }
    
    deinit {
        network.cancelAllRequests()
    }
    
    fileprivate func handleRequestResponse<U: BaseCodable>(_ result: Result<U>, completionHandler: @escaping (_ data: U?)->()) {
        view?.stopLoading()
        switch result {
        case .success(let data):
            if (data.status?.lowercased() ?? "") == "true" {
                DispatchQueue.main.async {
                    completionHandler(data)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(data)
                    self.view?.showAlert(with: data.message ?? "Error".localized)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completionHandler(nil)
                self.view?.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    func request<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, completionHandler: @escaping (_ data: U?)->()) {
        view?.startLoading()
        
        network.request(request, decodeTo: model) {[weak self] (result) in
            self?.handleRequestResponse(result, completionHandler: completionHandler)
        }
    }
    
    func request<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, showLoader: Bool = true, completionHandler: @escaping (_ data: U?)->()) {
        if showLoader {
            view?.startLoading()
        }
        network.request(request, decodeTo: model) {[weak self] (result) in
            self?.handleRequestResponse(result, completionHandler: completionHandler)
        }
    }
    
    func upload<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, data: [UploadData], completionHandler: @escaping(_ data: U?)->()) {
        guard let view = view else { return }
        view.startLoading()
        network.upload(request, data: data, decodedTo: model) {[weak self] (result) in
            self?.handleRequestResponse(result, completionHandler: completionHandler)
        }
    }
    
    func downloadFile(url: String, completionHandler: @escaping (_ data: String?)->()) {
        print(url)
        let name =  "audio\(Helper.randomString(length: 8)).m4a"
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(name)
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(url, to: destination).response { response in
            if response.destinationURL != nil {
                completionHandler(name)
            }else{
                completionHandler(nil)
            }
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
