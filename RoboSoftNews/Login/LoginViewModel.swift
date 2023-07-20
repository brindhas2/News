//
//  LoginViewModel.swift
//  RoboSoftNews
//
//  Created by Brindha S on 19/07/23.
//

import Foundation

class LoginViewModel: NSObject {
    override init() {
        super.init()
    }
    
    func isValidUserName(_ userName: String) -> Bool {
        guard userName.count > 0 else { return false }

        let allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%'^,()+.:|=?@/][_`{}\\!;-~"
       return userName.isAllowedCharacter(allowed)
    }
    
    func isValidPassword(_ pswd: String) -> Bool {
        guard pswd.count > 0 else { return false }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pswd)
        
    }
    
    func saveLoginDetails(_ userName: String?, _ pswd: String?) {
        UtilsCacheManager.shared.userName = userName
        UtilsCacheManager.shared.password = pswd
    }
}
