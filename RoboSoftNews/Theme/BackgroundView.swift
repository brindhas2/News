//
//  BackgroundView.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import UIKit

class BackgroundView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //initWithFrame to init view from code
     override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
     }
     
     //initWithCode to init view from xib or storyboard
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setupView()
     }
     
     //common func to init our view
     private func setupView() {
         backgroundColor = .red //UIColor.appColor(.bgView)
     }
    
     /* @IBInspectable override var backgroundColor: UIColor? {
           set {
               self.backgroundColor = newValue
           }
           get {
               return self.backgroundColor
           }
       }*/
}
