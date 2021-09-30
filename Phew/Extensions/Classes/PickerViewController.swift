//
//  PickerViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol SendPickerViewSelection: AnyObject {
    func pickerResult(item: String)
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rowsData[o: row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = rowsData[o: row] {
            delegate?.pickerResult(item: item)
            selectedItem?(item)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    private weak var delegate: SendPickerViewSelection?
    var rowsData: [String]
    
    var selectedItem: ((_ item: String)->())?
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    init(itemsToShow: [String], delegate: SendPickerViewSelection? = nil) {
        self.delegate = delegate
        rowsData = itemsToShow
        super.init(nibName: nil, bundle: nil)
        
        if itemsToShow.isEmpty {
            dismiss(animated: false, completion: nil)
            return
        }
        
        pickerView.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        let dismisslaView = UIView()
        view.addSubview(dismisslaView)
        dismisslaView.fillSuperviewSafeArea()
        dismisslaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMe)))
        
        let pickerViewBackView = UIView()
        pickerViewBackView.backgroundColor = .gray
        view.addSubview(pickerViewBackView)
        pickerViewBackView.widthAnchorWithMultiplier(multiplier: 1)
        pickerViewBackView.heightAnchorConstant(constant: 150)
        pickerViewBackView.centerXInSuperview()
        pickerViewBackView.bottomAnchorSuperView(constant: 0)
        
        pickerViewBackView.addSubview(pickerView)
        pickerView.fillSuperview(padding: .init(top: 4, left: 4, bottom: 4, right: 4))
        
        guard let firstItem = rowsData[o: 0] else { return }
        delegate?.pickerResult(item: firstItem)
        selectedItem?(firstItem)
    }
    
    @objc
    private func dismissMe() {
        dismiss(animated: true, completion: nil)
    }
}

extension Collection {
    subscript(o index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
