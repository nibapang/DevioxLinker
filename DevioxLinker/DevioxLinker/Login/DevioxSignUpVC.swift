//
//  SignUpVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit

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
    
    //MARK: - Funcions
    func registerUser(username: String, email: String, password: String, confirmPassword: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let signUpURL = URL(string: "https://devioxlinker.hirenow.co.in/api/register")!
        var request = URLRequest(url: signUpURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let signUpData = DevioxSignUpRequest(first_name: username, email: email, password: password, password_confirmation: confirmPassword)
        
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
            return
        }
        
        // Call the registerUser function with the provided information
        registerUser(username: username, email: email, password: password, confirmPassword: confirmPassword) { result in
            switch result {
            case .success(let data):
                // Handle successful registration
                print("dhsgh: \(data)")
                print("Registration successful")
                Utils.showAlert(title: "Success", message: "Register Successfully", from: self)
                case .failure(let error):
                // Handle error
                print("Error: \(error)")
            }
        }
    }
}
