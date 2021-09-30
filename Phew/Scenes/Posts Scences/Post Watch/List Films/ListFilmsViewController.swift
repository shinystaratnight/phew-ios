//
//  MoviePostViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ListFilmsViewController: UITableViewController, BaseViewProtocol, UISearchBarDelegate{
    
    private let searchbar = UISearchBar()
    lazy private  var repo  =  Repository(view: self)
    private var arrFilms = [MoviFilm]()
    weak var deleget :AddNewPostProtocol?
    
    let network = Network()
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        navigationItem.titleView = searchbar
        searchbar.backgroundColor = .mainRed
        tableView.showsVerticalScrollIndicator = false
        searchbar.delegate = self
        searchbar.placeholder = "Enter film name".localized
        tableView.registerCellNib(cellClass: PostWatchTableViewCell.self)
        
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.backgroundColor = .backgroundColor
        fetchPopularMovie()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostWatchTableViewCell", for: indexPath) as! PostWatchTableViewCell
        cell.dataItem = arrFilms[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let film = arrFilms[indexPath.row]
        let vc  = PostWatchViewController(film: film)
        vc.didAddPostWatch = { [weak self ] in
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
            arrFilms.removeAll()
            tableView.reloadData()
            return
        }
        featchFilms(textSearch: searchText, page: 1)
    }
    
    
}
extension ListFilmsViewController {
    private func featchFilms(textSearch:String, page:Int){
        network.request(APIRouter.filmMovi(text: textSearch, page: page), decodeTo: MoviFilmData.self) {  [weak self](response) in
            switch response {
            
            case .success(let value):
                guard let data = value.results else{return}
                self?.arrFilms = data
                self?.tableView.reloadData()
                
            case .failure(let error):
                self?.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    private func fetchPopularMovie() {
        self.startLoading()
        network.request(APIRouter.fetchMoviePopular, decodeTo: PopularMovieModel.self) { [weak self](response) in
            self?.stopLoading()
            switch response {
            
            case .success(let value):
                guard let data = value.data else {return}
                data.forEach({
                    if let movie = $0.movieDetail {
                        self?.arrFilms.append(movie)
                    }
                })
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(with: error.localizedDescription)
            }
        }
    }
}
