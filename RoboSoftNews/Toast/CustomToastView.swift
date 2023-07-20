//
//  CustomToastView.swift
//  Outfitted
//
//  Created by Leticia Rodriguez on 3/10/21.
//

import UIKit

public class CustomToastView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var toastMessageLabel: UILabel!
    @IBOutlet private weak var toastTitleLabel: UILabel!
    @IBOutlet private weak var rightSideButton: UIButton!
    
    var toastTappedNotification: () -> () = {}
    var actionTappedNotification: () -> () = {}
    
    private var toastData: ToastData?
    public var constraint: NSLayoutConstraint?
    public var viewController: UIViewController?
    
    // MARK: - Initializers
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
     
    private func setUI() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toastTapped))
        contentView.addGestureRecognizer(gesture)
        
       // let gestureLabel = UITapGestureRecognizer(target: self, action: #selector(actionLabelTapped))
       // actionLabel.addGestureRecognizer(gestureLabel)
    }
    
    @IBAction func rightSideButtonTapped(_ button: UIButton!) {
        actionTappedNotification()
    }
    
    func set(constraint: NSLayoutConstraint,
             viewController: UIViewController) {
        self.constraint = constraint
        self.viewController = viewController
    }
    
    func configToast(data: ToastData) {
        if let cornerRadius = data.cornerRadius {
            contentView.layer.cornerRadius = cornerRadius
        } else {
            contentView.layer.cornerRadius = 3
        }
        
        contentView.backgroundColor = data.backgroundColor
        
        toastTitleLabel.textColor = data.titleColor
        toastTitleLabel.text = data.title
        toastTitleLabel.font = data.font
        toastTitleLabel.textAlignment = data.textAlignment
        
        toastMessageLabel.textColor = data.textColor
        toastMessageLabel.text = data.message
        toastMessageLabel.font = data.font
        toastMessageLabel.textAlignment = data.textAlignment
        toastData = data
    }
    
    @objc private func toastTapped() {
        toastTappedNotification()
    }
    
    @objc private func actionLabelTapped() {
        actionTappedNotification()
    }
    
    public func hide() {
        guard let toastData = self.toastData else { return }
        self.hideByOrientation()
        UIView.animate(withDuration: toastData.timeDismissal) {
            self.viewController?.view.setNeedsLayout()
            self.viewController?.view.layoutIfNeeded()
        }
    }
    
    private func hideByOrientation() {
        guard let toastData = self.toastData else { return }
        switch toastData.orientation {
        case .bottomToTop:
            self.constraint?.constant = toastData.toastHeight
        case .topToBottom:
            self.constraint?.constant = -toastData.toastHeight
        case .leftToRight:
            self.constraint?.constant = -UIScreen.main.bounds.width
        case .rightToLeft:
            self.constraint?.constant = UIScreen.main.bounds.width
        case .fadeIn: dismissFadeIn()
        case .fadeOut: dismissFadeOut()
        }
    }
    
    private func dismissFadeIn() {
        UIView.animate(withDuration: 3.0,
                       delay: 0.1,
                       options: [.curveEaseOut],
                       animations: {
                        self.alpha = 0.0
                       }, completion: {(isCompleted) in
                        self.removeFromSuperview()
                       })
    }
    
    private func dismissFadeOut() {
        UIView.animate(withDuration: 3.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        self.alpha = 0.0
                       }, completion: {(isCompleted) in
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (self.toastData?.timeDismissal ?? 0.0),
                                                      execute: {
                                                        self.removeFromSuperview()
                                                      })
                        
                        
                       })
    }
}
