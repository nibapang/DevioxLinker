//
//  LoginVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit
import FirebaseAuth
//import SVProgressHUD

class DevioxLoginVC: UIViewController {
    
    //MARK: - Declare IBOutlet
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK: - Declare Variable
    
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(UserDefaults.standard.value(forKey: "accessToken") ?? "no value")
        let alertController = UIAlertController(title: "Alert", message: "Please check Terms and Conditions.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Declare IBAction
    @IBAction func btnLogin(_ sender: UIButton) {
        let email = txtUsername.text ?? ""
        let password = txtPassword.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) {[self]
            authResult, error in
            if let error = error{
                Utils.showAlert(title: "Error In Login", message: "Missing info please fill correct ingo for login", from: self)
            }else{
                print("Login successed")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let initialViewController = storyboard.instantiateInitialViewController() else {
                        return
                    }
                    UIApplication.shared.windows.first?.rootViewController = initialViewController
                    UserDefaults.standard.setValue(true, forKey: "login")
                }
            }
        }
        
    }
    
    @IBAction func btnShowConfirmPass(_ sender: UIButton) {
        if txtPassword.isSecureTextEntry == true {
            txtPassword.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ic_password_hide"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            sender.setImage(UIImage(named: "ic_password_show"), for: .normal)
        }
    }
    
    
    @IBAction func termsConditionBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
            self.navigationController?.pushViewController(termsVC, animated: true)
        }
    }
    
}
