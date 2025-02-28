//
//  ProfileVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import UIKit
import FirebaseAuth
class DevioxProfileVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblPostCount: UILabel!
    @IBOutlet weak var btnLoinLogout: UIButton!
    
    // MARK: - Variables
    var arrImages = [UIImage]()

    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadSavedImages()
        lblTitle()
        lblName.text = "user_\(UUID())"
        lblPostCount.text = "\(arrImages.count)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedImages()
        self.lblTitle ()
      
    }
    
    func lblTitle() {
        let loginOrNot = UserDefaults.standard.bool(forKey: "login")
        if loginOrNot == false {
            btnLoinLogout.setTitle("Login or Sign Up", for: .normal)
            btnDelete.isHidden = true
        } else {
            btnLoinLogout.setTitle("Logout", for: .normal)
            btnDelete.isHidden = false
        }
    }
    
    func logoutUser(apiToken: String, completion: @escaping (Bool, String) -> Void) {
           // API URL
           guard let url = URL(string: "https://devioxlinker.hirenow.co.in/api/logout") else {
               completion(false, "Invalid URL")
               return
           }

           // Create URL Request
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

           // Perform API Call
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               // Handle Network Error
               if let error = error {
                   completion(false, "Logout Error: \(error.localizedDescription)")
                   return
               }
               
               // Handle Response
               guard let data = data else {
                   completion(false, "No Data Received")
                   return
               }
               
               // Decode JSON Response
               do {
                   let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                   let status = responseJSON?["status"] as? Bool ?? false
                   let message = responseJSON?["message"] as? String ?? "Unknown error"
                   
                   DispatchQueue.main.async {
                       completion(status, message)
                   }
                   
               } catch {
                   completion(false, "Decoding Error: \(error.localizedDescription)")
               }
           }
           task.resume()
       }
    // MARK: - Functions
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }

    func loadSavedImages() {
        if let savedDataArray = UserDefaults.standard.array(forKey: "savedImages") as? [Data] {
            arrImages = savedDataArray.compactMap { UIImage(data: $0) }
        }
        collectionView.reloadData()
    }
    @IBAction func btnLoginSignUp(_ sender: Any) {
        let loginOrNot = UserDefaults.standard.bool(forKey: "login")
        if loginOrNot == true {
//            let userToken = UserDefaults.standard.value(forKey: "AuthToken") as! String
            do{
                try Auth.auth().signOut()
                UserDefaults.standard.setValue(false, forKey: "login")
                UserDefaults.standard.removeObject(forKey: "AuthToken")
                var window: UIWindow?
                // Load the storyboard named "Main"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // Instantiate the initial view controller from the storyboard
                let initialViewController = storyboard.instantiateInitialViewController()
                // Set the root view controller of the app's window
                window?.rootViewController = initialViewController
                // Make the window visible
                window?.makeKeyAndVisible()
                
                self.tabBarController?.selectedIndex = 0
            }catch{
                Utils.showAlert(title: "Failed", message: "Logout failed", from: self)
            }
        } else {
            var window: UIWindow?
            // Load the storyboard named "Main"
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            // Instantiate the initial view controller from the storyboard
            let initialViewController = storyboard.instantiateInitialViewController()
            // Set the root view controller of the app's window
            window?.rootViewController = initialViewController
            // Make the window visible
            window?.makeKeyAndVisible()
            let vc = storyboard.instantiateViewController(withIdentifier: "AuthNavigationVC")as! DevioxAuthNavigationVC
            navigationController?.pushViewController(vc, animated: false)
        }
        self.lblTitle ()
        
    }
    @IBAction func btnDelete(_ sender: Any) {
        
        Auth.auth().currentUser?.delete(completion: { error in
            if let err = error {
                Utils.showAlert(title: "Alert", message: err.localizedDescription, from: self)
            } else {
                Utils.showAlert(title: "Delete", message: "Your account was successfully deleted", from: self)
                UserDefaults.standard.setValue(false, forKey: "login")
                UserDefaults.standard.removeObject(forKey: "AuthToken")
               
                var window: UIWindow?
                // Load the storyboard named "Main"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // Instantiate the initial view controller from the storyboard
                let initialViewController = storyboard.instantiateInitialViewController()
                // Set the root view controller of the app's window
                window?.rootViewController = initialViewController
                // Make the window visible
                window?.makeKeyAndVisible()
                
                self.tabBarController?.selectedIndex = 0
            }
        })
        self.lblTitle()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension DevioxProfileVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        // Remove previous imageView to avoid overlapping
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = arrImages[indexPath.item]
        imageView.clipsToBounds = true

        cell.contentView.addSubview(imageView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 3 - 1  // Adjust grid size
        return CGSize(width: width, height: width)
    }
}
