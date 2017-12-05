//
//  UINavigationController+preferredStatusBarStyle.swift
//  Final Project
//
//  Created by Mia Tortolani on 11/29/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
}
