//
//  LoginVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//
struct LoginRequest: Codable {
    let email: String
    let password: String
}


import UIKit
import Network

import SVProgressHUD
let monitor = NWPathMonitor()

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
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    //MARK: - Functions
    func loginUser(email: String, password: String) {
        // API URL
        let url = URL(string: "https://devioxlinker.hirenow.co.in/api/login")!
        
        // Prepare Request Body
        let loginData = LoginRequest(email: email, password: password)
        guard let jsonData = try? JSONEncoder().encode(loginData) else { return }
        
        // Create URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Perform API Call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle Network Error
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                return
            }
            
            // Handle Response
            guard let data = data else {
                print("No Data Received")
                return
            }
            
            // Decode JSON Response
            do {
                let loginResponse = try JSONDecoder().decode(DevioxLoginResponse.self, from: data)
                
                DispatchQueue.main.async {
                    if loginResponse.status {
                        print("Login Successful: \(loginResponse.message)")
                        print("User ID: \(loginResponse.data.id )")
                        print("API Token: \(loginResponse.data.apiToken )")
                        let AuthToken = loginResponse.data.apiToken
                        UserDefaults.standard.setValue(AuthToken, forKey: "AuthToken")
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let initialViewController = storyboard.instantiateInitialViewController() else {
                                return
                            }
                            UIApplication.shared.windows.first?.rootViewController = initialViewController
                            UserDefaults.standard.setValue(true, forKey: "login")
                        }
                    } else {
                        print("Login Failed: \(loginResponse.message)")
                    }
                }
                
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    
    //MARK: - Declare IBAction
    @IBAction func btnLogin(_ sender: UIButton) {
        let email = txtUsername.text ?? ""
        let password = txtPassword.text ?? ""
        
        if !isInternetAvailable() {
            Utils.showAlert(title: "No Internet", message: "Please check your internet connection and try again.", from: self)
            return
        }
        
        if !isValidEmail(email) {
            Utils.showAlert(title: "Error", message: "Please enter a valid email address", from: self)
            return
        }
        
        if password.count < 8 {
            Utils.showAlert(title: "Error", message: "Password must be at least 8 characters long", from: self)
            return
        }
        

        
        loginUser(email: email, password: password)
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
    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

//MARK: - DataSource and Delegate Methods
func isInternetAvailable() -> Bool {
    return monitor.currentPath.status == .satisfied
}

