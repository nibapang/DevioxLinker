//
//  HomeListCell.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import UIKit

class DevioxHomeListCell: UITableViewCell{
    
    @IBOutlet weak var constImgHeight: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnMore: UIButton!
    
    
    var setShare: ((UIImage?)->Void)?
    var likeAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.image = UIImage(named: "demo")
        adjustImageHeight()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func handleImageDoubleTap() {
        likeAction?()
    }
    
    @IBAction func btnShare(_ sender: Any) {
        setShare?(img.image)
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        likeAction?()
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "More option", message: nil, preferredStyle: .actionSheet)
                
        let option1 = UIAlertAction(title: "Report", style: .default) { _ in
            self.showReportAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }

        actionSheet.addAction(option1)
        actionSheet.addAction(cancelAction)
        
        self.findViewController()?.present(actionSheet, animated: true)
    }
    
    func showReportAlert() {
        // Create an UIAlertController with the style set to Alert
        let alertController = UIAlertController(title: "Report", message: "Please select a reason for the report", preferredStyle: .alert)
        
        // Add options for the user to select a reason for the report
        let option1 = UIAlertAction(title: "Inappropriate Content", style: .default) { _ in
            print("Report reason: Inappropriate Content")
            self.submitReport(reason: "Inappropriate Content")
        }
        let option2 = UIAlertAction(title: "Spam or Advertisement", style: .default) { _ in
            print("Report reason: Spam or Advertisement")
            self.submitReport(reason: "Spam or Advertisement")
        }
        let option3 = UIAlertAction(title: "Fraudulent Behavior", style: .default) { _ in
            print("Report reason: Fraudulent Behavior")
            self.submitReport(reason: "Fraudulent Behavior")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add the actions to the alert controller
        alertController.addAction(option1)
        alertController.addAction(option2)
        alertController.addAction(option3)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter additional details"
        }
        
        // Present the alert controller
        self.findViewController()?.present(alertController, animated: true)
    }

    // Handle the report submission
    func submitReport(reason: String) {
        // Here you would typically send the report to a server or handle it as needed
        print("Report submitted with reason: \(reason)")
        
        // Show a success message after the report is submitted
        showReportSuccessMessage()
    }
    
    func showReportSuccessMessage() {
        let successAlert = UIAlertController(title: "Report Submitted", message: "Thank you for reporting. Your feedback is important to us.", preferredStyle: .alert)
        
        // Add an "OK" action to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        successAlert.addAction(okAction)
        
        // Present the success alert
        self.findViewController()?.present(successAlert, animated: true, completion: nil)
    }
    
    
    func adjustImageHeight() {
        guard let image = img.image else { return }
        let aspectRatio = min((image.size.height / image.size.width), 2)
        let newHeight = img.frame.width * aspectRatio
        constImgHeight.constant = newHeight
        layoutIfNeeded()
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.img.image = image
                self.adjustImageHeight()
            }
        }.resume()
    }
}
