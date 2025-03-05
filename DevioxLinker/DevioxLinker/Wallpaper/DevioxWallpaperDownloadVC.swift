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
    
    @IBAction func reportBlockBtn(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "More Options", message: nil, preferredStyle: .actionSheet)
                
        let reportAction = UIAlertAction(title: "Report", style: .default) { _ in
            self.showReportAlert()
        }
        
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
            self.showBlockAlert()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(reportAction)
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
        
    }
    
    func showReportAlert() {
        let alertController = UIAlertController(title: "Report", message: "Please select a reason for the report", preferredStyle: .alert)
        
        let option1 = UIAlertAction(title: "Inappropriate Content", style: .default) { _ in
            self.submitReport(reason: "Inappropriate Content")
        }
        let option2 = UIAlertAction(title: "Spam or Advertisement", style: .default) { _ in
            self.submitReport(reason: "Spam or Advertisement")
        }
        let option3 = UIAlertAction(title: "Fraudulent Behavior", style: .default) { _ in
            self.submitReport(reason: "Fraudulent Behavior")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(option1)
        alertController.addAction(option2)
        alertController.addAction(option3)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter additional details"
        }
        
        self.present(alertController, animated: true)
    }
    
    func submitReport(reason: String) {
        print("Report submitted with reason: \(reason)")
        showReportSuccessMessage()
    }
    
    func showReportSuccessMessage() {
        let successAlert = UIAlertController(title: "Report Submitted", message: "Thank you for reporting. Your feedback is important to us.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        successAlert.addAction(okAction)
        self.present(successAlert, animated: true, completion: nil)
    }
    
    func showBlockAlert() {
        let alertController = UIAlertController(title: "Block User", message: "Please enter a reason for blocking this user.", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter reason"
        }
        
        let submitAction = UIAlertAction(title: "Block", style: .destructive) { _ in
            if let reason = alertController.textFields?.first?.text, !reason.isEmpty {
                self.submitBlockRequest(reason: reason)
            } else {
                self.submitBlockRequest(reason: "No reason provided")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func submitBlockRequest(reason: String) {
        print("User blocked for reason: \(reason)")
        showBlockSuccessMessage()
    }
    
    func showBlockSuccessMessage() {
        let successAlert = UIAlertController(title: "User Blocked", message: "We will review this user and block them within 24 hours.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        successAlert.addAction(okAction)
        self.present(successAlert, animated: true, completion: nil)
    }
}
