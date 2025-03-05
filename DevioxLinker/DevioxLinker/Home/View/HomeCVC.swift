//
//  HomeCVC.swift
//  WonderWall Gallery
//
//  Created by Nirav on 31/01/24.
//

import UIKit

class HomeCVC: UICollectionViewCell {
    
    @IBOutlet weak var imgWallPaper: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        
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
        
        self.findViewController()?.present(actionSheet, animated: true)
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
        
        self.findViewController()?.present(alertController, animated: true)
    }
    
    func submitReport(reason: String) {
        print("Report submitted with reason: \(reason)")
        showReportSuccessMessage()
    }
    
    func showReportSuccessMessage() {
        let successAlert = UIAlertController(title: "Report Submitted", message: "Thank you for reporting. Your feedback is important to us.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        successAlert.addAction(okAction)
        self.findViewController()?.present(successAlert, animated: true, completion: nil)
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
        
        self.findViewController()?.present(alertController, animated: true)
    }
    
    func submitBlockRequest(reason: String) {
        print("User blocked for reason: \(reason)")
        showBlockSuccessMessage()
    }
    
    func showBlockSuccessMessage() {
        let successAlert = UIAlertController(title: "User Blocked", message: "We will review this user and block them within 24 hours.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        successAlert.addAction(okAction)
        self.findViewController()?.present(successAlert, animated: true, completion: nil)
    }
    
}
