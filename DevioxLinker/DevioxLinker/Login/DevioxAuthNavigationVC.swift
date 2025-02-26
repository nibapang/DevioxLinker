//
//  AuthNavigationVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit

class DevioxAuthNavigationVC: UIViewController {
    
    //MARK: - Declare IBOutlets
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var swipeDown: UIView!
    @IBOutlet weak var swipeUp: UIView!
    
    //MARK: - Declare Variables
    
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let fontSize = UIScreen.main.bounds.width / 18.75
        lbl1.font = UIFont(name: "STIX Two Text Bold", size: fontSize)
        lbl2.font = UIFont(name: "STIX Two Text Bold", size: fontSize)
        setupGestures()
    }
    
    //MARK: - Functions
    private func setupGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        self.swipeUp.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        self.swipeDown.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            navigateToLogin()
        } else if gesture.direction == .down {
            navigateToSignUp()
        }
    }
    
    private func navigateToLogin() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? DevioxLoginVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func navigateToSignUp() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? DevioxSignUpVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Declare IBAction
    
}
