//
//  ThemeHelper.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import UIKit

enum AssetsColor {
   case bgView
case toastBg
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .bgView:
            return UIColor(named: "bgViewColor")
        case .toastBg:
            return UIColor(named: "ToastBgColor")
        }
    }
}
