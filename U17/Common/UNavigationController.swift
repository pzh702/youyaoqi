//
//  UNavigationController.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/2.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit

enum UNavigationBarStyle {
	case theme
    case clear
    case white
}

extension UINavigationController{


	func barStyle(style:UNavigationBarStyle) -> Void {
		switch style {
        case .theme:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
        }
	}
}
