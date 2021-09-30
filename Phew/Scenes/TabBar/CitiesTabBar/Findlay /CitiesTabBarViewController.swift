//
//  CitiesTabBarViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class CitiesTabBarViewController: BaseViewController {
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var selectCountryId: Int?
    private var pickerCountry = DataPicker()
    private var arrCountry = [CountryModel]()
    private var arrCity = [CityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setNavBarColor()
        initCountryPicker()
        featchCountry()
        setButonsNav()
        setLogoNav()
    }
    
    private func initCountryPicker() {
        pickerCountry.initPickerView(txtFileld: txtCountry, view: view) { [weak self](index) in
            guard let _index = index else{return}
            guard let self = self else {return}
            let countryId = self.arrCountry[_index].id
            self.selectCountryId = countryId
            self.getCity(countryId: countryId)
        }
    }
    
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: CitiesTableViewCell.self)
    }
}

extension CitiesTabBarViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CitiesTableViewCell
        cell.item = arrCity[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityId = arrCity[indexPath.row].id, let _countryId = selectCountryId else{return}
        push(ShowCityPostsViewController(cityId: cityId, countryId: _countryId))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
extension CitiesTabBarViewController {
    private func featchCountry() {
        repo.request(BaseModelWith<[CountryModel]>.self, FindalyRouter.country) { [weak self] (data) in
            guard let self = self else {return}
            self.arrCountry = data?.data ?? []
            print(self.arrCountry.count)
            self.pickerCountry.arr =  self.arrCountry.map({$0.name ?? ""})
        }
    }
    
    func getCity(countryId: Int) {
        repo.request(BaseModelWith<[CityModel]>.self, FindalyRouter.city(countryId: countryId)) { [weak self](data) in
            guard let self = self else {return}
            self.arrCity = data?.data ?? []
            self.tableView.reloadData()
        }
    }
}
