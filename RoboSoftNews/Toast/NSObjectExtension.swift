//
//  NSObjectExtension.swift
//  CustomToastView
//
//  Created by Leticia Rodriguez on 5/29/21.
//

import Foundation
import UIKit

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
 extension UITableViewCell {
    /// Class property that returns the cell identifier value.
    class var identifier: String {
        return String(describing: self)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension String {
    func isAllowedCharacter(_ charcterSet: String) -> Bool {
        let invertedSet = NSCharacterSet(charactersIn: charcterSet).inverted
        let filtered = self.components(separatedBy: invertedSet).joined(separator: "")
        return (self == filtered)
    }
}
