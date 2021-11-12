//
//  UIView + Extension.swift
//  CoffeeBreak
//
//  Created by Borna Ungar on 30.10.2021..
//

import Foundation
import UIKit
extension UIView {
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
