//
//  UITableViewCell + Extension.swift
//  Phew
//
//  Created by Mohamed Akl on 9/13/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
}


extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = numberOfSections
        if section > 0 {
            let row = numberOfRows(inSection: section - 1)
            if row > 0 {
                scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
            }
        }
    }
}
