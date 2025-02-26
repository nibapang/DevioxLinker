//
//  CustomTabBarController.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit

class DevioxTabBarController: UITabBarController {
    
    let floatingButton: UIButton = {
        let button = UIButton()
        let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large))
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupFloatingButton()
        tabBar.clipsToBounds = false
        
    }
    
    private func setupTabBar() {
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! DevioxHomeVC
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.setNavigationBarHidden(true, animated: false)
        
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchVC")as! DevioxSearchVC
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.setNavigationBarHidden(true, animated: false)
        
        let addPostVC = storyboard?.instantiateViewController(withIdentifier: "MyPostVC")as! DevioxMyPostVC
        
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "VedioVC")as! DevioxVedioVC
        chatVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "video"), selectedImage: UIImage(systemName: "video.fill"))
        let chatNav = UINavigationController(rootViewController: chatVC)
        chatNav.setNavigationBarHidden(true, animated: false)
        
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC")as! DevioxProfileVC
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.setNavigationBarHidden(true, animated: false)
        
        self.viewControllers = [homeNav, searchNav, addPostVC, chatVC, profileNav]
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemOrange
        tabBar.unselectedItemTintColor = .gray
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
    }
    
    private func setupFloatingButton() {
        let safeAreaBottom = view.safeAreaInsets.bottom
        floatingButton.frame = CGRect(
            x: (view.bounds.width / 2) - 40,
            y: -20 - safeAreaBottom,
            width: 80,
            height: 80
        )
        
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        tabBar.addSubview(floatingButton)
        tabBar.bringSubviewToFront(floatingButton)
    }
    
    @objc private func floatingButtonTapped() {
        let actionVC = storyboard?.instantiateViewController(withIdentifier: "MyPostVC")as! DevioxMyPostVC
        present(actionVC, animated: true)
    }
    
}
