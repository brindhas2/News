//
//  ToastData.swift
//  CustomToastView-swift
//
//  Created by Leticia Rodriguez on 5/31/21.
//

import UIKit
import Foundation

public struct ToastData {
    //var type: CustomToastType = .simple
    var font = UIFont.systemFont(ofSize: 14,
                                 weight: .light)
    var titleColor: UIColor = .red
    var textColor: UIColor = .black
    var backgroundColor: UIColor = UIColor.appColor(.toastBg) ?? .yellow
    var title = "Hello!"
    var message = "Hello! I'm a toast message!"
    var actionTextColor: UIColor = .black
    var actionText: String? = nil
    var actionFont = UIFont.systemFont(ofSize: 14,
                                       weight: .regular)
    var orientation: AnimationType = .topToBottom
    var toastHeight: CGFloat = 54
    var sideDistance: CGFloat = 16
    var cornerRadius: CGFloat? = nil
    var timeDismissal = 0.5
    var verticalPosition: CGFloat = 54
    var shouldDismissAfterPresenting = true
    var textAlignment: NSTextAlignment = .left
    var leftIconImageContentMode: UIView.ContentMode = .scaleAspectFit
    
    public init() {
        
    }
}
