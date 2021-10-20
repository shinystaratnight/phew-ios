//
//  PickerData.swift
//  Base
//
//  Created by Ahmed Elesawy on 11/28/20.
//  Copyright © 2020 Ahmed Elesawy. All rights reserved.
//

import Foundation
import UIKit

class DataPicker:  UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    static var shared = DataPicker()
    var arr = [String]() {
        didSet{
            if arr.count > 0 {
                isEmptyData = false
            }else{
                arr =  ["No Data Found".localized]
                isEmptyData = true
            }
        }
    }
    private var txtFiled : UITextField!
    static let instance = DataPicker()
    private var selectedIndex:Int?
    private var view : UIView!
    private var isEmptyData = true    
    private var completion: ((Int?) -> Void)?
    private var picker = UIPickerView()
    
    func initPickerView(arrString:[String] = [],txtFileld : UITextField , view : UIView, complition:((Int?) -> Void)?) {
        self.txtFiled = txtFileld
        self.view = view
        self.arr = arrString
        self.delegate = self
        txtFileld.inputView = self
        createToolbar()
        if  arrString.isEmpty {
            isEmptyData = true
        }else{
            isEmptyData = false
        }
        complition?(nil)
        txtFileld.text = nil
        self.completion = complition
    }
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtFiled.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        if isEmptyData {
            completion?(nil)
        }else{
            if  txtFiled.text == nil || txtFiled.text == "" {
                txtFiled.text = arr.first
                completion?(0)
            } else {
                completion?(selectedIndex)
            }
        }
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard arr.count > 0  else {
            view.endEditing(true)
            return nil}
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard arr.count > 0 else{return}
        if !isEmptyData {
            txtFiled.text = arr[row]
            //            completion?(row)
            selectedIndex = row
        }
    }
}
