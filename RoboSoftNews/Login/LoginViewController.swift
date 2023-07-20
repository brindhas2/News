//
//  LoginViewController.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import UIKit

class LoginViewController: UIViewController {
//   Reference of user name text field
    @IBOutlet weak var userNameTextField: UITextField!
    
//    Reference of password text field
    @IBOutlet weak var pswdTextField: UITextField!
    
    private var loginViewModel : LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        // Do any additional setup after loading the view.
    }
    
    /// Method to handle login button action
    /// - Parameter id: Login buttion reference
    @IBAction func loginButtonClicked(id: UIButton!) {
        
        if !loginViewModel.isValidUserName(userNameTextField.text ?? "") {
            let message = userNameTextField.text?.count == 0 ? LoginConstants.invalidUserLengh : LoginConstants.invalidUser
            Toast.Builder()
                .title(LoginConstants.error)
                 .message(message)
                 .build()
                 .show(on: self)
            return
        }
        if !loginViewModel.isValidPassword(pswdTextField.text ?? "") {
            let message = pswdTextField.text?.count == 0 ? LoginConstants.invalidPasswordLength : LoginConstants.invalidPassword
            Toast.Builder()
                .title(LoginConstants.error)
                 .message(message)
                 .build()
                 .show(on: self)
            return
        }
        
        loginViewModel.saveLoginDetails(userNameTextField.text, pswdTextField.text)
        userNameTextField.text = nil
        pswdTextField.text = nil
        view.endEditing(true)
        performSegue(withIdentifier: Navigation.fromloginToNewsList, sender: self)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    
}
