//
//  SignUpVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

struct SignUpRequest: Codable {
    let first_name: String
    let email: String
    let password: String
    let password_confirmation: String
}

import UIKit
import Network

class DevioxSignUpVC: UIViewController {
    
    //MARK: - Declare IBOutlet
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    //MARK: - Declare Variable
    var errorMessage = String()
    let monitor = NWPathMonitor()
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    //MARK: - Funcions
    func registerUser(username: String, email: String, password: String, confirmPassword: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let signUpURL = URL(string: "https://devioxlinker.hirenow.co.in/api/register")!
        var request = URLRequest(url: signUpURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let signUpData = SignUpRequest(first_name: username, email: email, password: password, password_confirmation: confirmPassword)
        
        do {
            request.httpBody = try JSONEncoder().encode(signUpData)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    // SVProgressHUD.dismiss()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    // Handle server errors here
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    let errorMessage = "Server Error: \(statusCode)"
                    completion(.failure(NSError(domain: "HTTP", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    //  SVProgressHUD.dismiss()
                    return
                }
                
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(DevioxSignupAPIResponse.self, from: data)
                        // UserDefaults.standard.set(model.data.access_token, forKey: "token")
                        self.errorMessage = model.message
                        //   SVProgressHUD.dismiss()
                        Utils.showAlert(title: "Done", message: self.errorMessage, from: self)
                        completion(.success(data))
                    } catch {
                        completion(.failure(error))
                        //    SVProgressHUD.dismiss()
                        Utils.showAlert(title: "Error", message: "Something Went Wrong", from: self)
                        return
                    }
                } else {
                    completion(.failure(NSError(domain: "Data", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                    // SVProgressHUD.dismiss()
                }
            }
        }
        
        task.resume()
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
            Utils.showAlert(title: "Error", message: "All fields are required", from: self)
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
        
        if password != confirmPassword {
            Utils.showAlert(title: "Error", message: "Passwords do not match", from: self)
            return
        }
        
        if !isInternetAvailable() {
            Utils.showAlert(title: "No Internet", message: "Please check your internet connection and try again.", from: self)
            return
        }
        // Call the registerUser function with the provided information
        registerUser(username: username, email: email, password: password, confirmPassword: confirmPassword) { result in
            switch result {
            case .success(let data):
                // Handle successful registration
                print("dhsgh: \(data)")
                print("Registration successful")
                let alert = UIAlertController(title: "Success",
                                              message: "Registration successful",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
            }
        }
    }
    func isInternetAvailable() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}

//MARK: - DataSource and Delegate Methods

//class Utils {
//    static func showAlert(title: String, message: String, from viewController: UIViewController) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        
//        viewController.present(alertController, animated: true, completion: nil)
//    }
//}
func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

