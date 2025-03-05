//
//  SignUpVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit
import FirebaseAuth
class DevioxSignUpVC: UIViewController {

    //MARK: - Declare IBOutlet
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    //MARK: - Declare Variable
    var errorMessage = String()
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Declare IBAction
    @IBAction func btnShowPassword(_ sender: UIButton) {
        if txtPassword.isSecureTextEntry == true {
            sender.setImage(UIImage(named: "ic_password_hide"), for: .normal)
            txtPassword.isSecureTextEntry = false
        } else {
            sender.setImage(UIImage(named: "ic_password_show"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnShowConfirmPass(_ sender: UIButton) {
        if txtConfirmPassword.isSecureTextEntry == true {
            txtConfirmPassword.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ic_password_hide"), for: .normal)
        } else {
            txtConfirmPassword.isSecureTextEntry = true
            sender.setImage(UIImage(named: "ic_password_show"), for: .normal)
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignUp(_ sender: UIButton) {
       // SVProgressHUD.show()
        guard let username = txtUsername.text, !username.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty else {
            Utils.showAlert(title: "Empty", message: "fill the all field", from: self)
            return
        }
        
        if password == confirmPassword{
            Auth.auth().createUser(withEmail: email, password: password){
                authresult,error in
                if let error = error{
                    print("Error in sign in",error.localizedDescription)
                    Utils.showAlert(title: "Failed", message: "Registraition Failed", from: self)
                }else{
                    Utils.showAlert(title: "Success", message: "Register Successfully", from: self)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                   
                }
            }
        }else{
            
            Utils.showAlert(title: "Password Unmatched", message: "Password and confirm password does not matched", from: self)
        }
    }
    

    
    @IBAction func termConditionBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
            self.navigationController?.pushViewController(termsVC, animated: true)
        }
        
    }
    
}
