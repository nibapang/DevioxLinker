import UIKit

class DevioxHomeListCell: UITableViewCell {
    
    @IBOutlet weak var constImgHeight: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    var setShare: ((UIImage?) -> Void)?
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
    
    func showTermsClass() {
        if let viewController = self.findViewController(),
           let termsVC = viewController.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
            viewController.navigationController?.pushViewController(termsVC, animated: true)
        }
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
