//
//  WallpaperDownloadVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import Foundation
import UIKit
import SDWebImage

class DevioxWallpaperDownloadVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    private let checkmarkView = UIImageView()
    
    var imageUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        imgView.sd_setImage(with: URL(string: imageUrl))
        
        // Setup checkmark view
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = .systemGreen
        checkmarkView.alpha = 0
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkmarkView)
        
        NSLayoutConstraint.activate([
            checkmarkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkmarkView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 100),
            checkmarkView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func showSuccessAnimation() {
        checkmarkView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        checkmarkView.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.checkmarkView.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0) {
                self.checkmarkView.alpha = 0
            }
        }
    }
    
    @IBAction func btnDownload(_ sender: UIButton) {
        guard let image = imgView.image else {
            print("No image to download.")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully.")
            showSuccessAnimation()
        }
    }
}
