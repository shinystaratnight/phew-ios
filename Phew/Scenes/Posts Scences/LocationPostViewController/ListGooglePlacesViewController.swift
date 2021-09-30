//
//  LocationPostViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import Alamofire

class ListGooglePlacesViewController: UITableViewController, BaseViewProtocol, UISearchBarDelegate {
    
   
    private let searchbar = UISearchBar()
    private var data: [MapsSearchData] = []
    weak var deleget : AddNewPostProtocol?
    let network = Network()
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        clearNavigationBackButtonTitle()
      
        navigationItem.titleView = searchbar
        searchbar.delegate = self
        searchbar.backgroundColor = .mainRed
        searchbar.placeholder = "Enter Place".localized
       
        tableView.registerCellNib(cellClass: LocationOnMapTableViewCell .self)
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.backgroundColor = .backgroundColor
       
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationOnMapTableViewCell", for: indexPath) as! LocationOnMapTableViewCell
        
        guard let item = data.getElement(at: indexPath.row) else{return UITableViewCell()}
//        let title =  item.name
//        let desc = item.formattedAddress
        cell.dataItem = item
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let region = data.getElement(at: indexPath.row) else {return}
        let vc = PostLocationViewController(location: region)
        vc.didAddPostLocation = { [weak self] in
            self?.deleget?.didAddNewPost()
            self?.dismissMePlease()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("Tetx")
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else{
            data.removeAll()
            
            tableView.reloadData()
            return
        }
        
        guard let searchText = searchBar.text, searchText.count > 0  else { return }
        data.removeAll()
        
        feachSearchPlaces(test: searchText)
    }
}

extension ListGooglePlacesViewController{
    private func feachSearchPlaces(test:String){
        network.request(APIRouter.searchGooglePlaces(text: test), decodeTo: MapsSearchModel.self) {  [weak self](response) in
            switch response {
            
            case .success(let value):
                guard let data = value.results else{return}
                self?.data = data
                           self?.tableView.reloadData()
                
            case .failure(let error):
                self?.showAlert(with: error.localizedDescription)
            }
        }
//        repo.request(MapsSearchModel.self, CoreRouter.searchGooglePlaces(text: test),showLoader: false) { [weak self] (response) in
//            guard let data = response?.results else{return}
//            self?.data = data
//            self?.tableView.reloadData()
//        }
    }
}

