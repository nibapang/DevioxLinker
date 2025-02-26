//
//  MyPostVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit

class DevioxMyPostVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var arrImages = [UIImage]() // Image array

    var imgNew: UIImage? {
        didSet {
            img.image = imgNew
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages() // Load saved images
    }
    
    @IBAction func btnCam(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func btnGal(_ sender: Any) {
        openGallery()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        guard let selectedImage = imgNew else { return }
        
        // Add image to array
        arrImages.append(selectedImage)
        
        // Save to UserDefaults
        saveImages()
        self.dismiss(animated: true)
    }
    
    func saveImages() {
        var imageDataArray = [Data]()
        
        for image in arrImages {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                imageDataArray.append(imageData)
            }
        }
        
        UserDefaults.standard.set(imageDataArray, forKey: "savedImages")
        UserDefaults.standard.synchronize()
    }
    
    func loadImages() {
        if let savedDataArray = UserDefaults.standard.array(forKey: "savedImages") as? [Data] {
            arrImages = savedDataArray.compactMap { UIImage(data: $0) }
        }
    }
}

extension DevioxMyPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgNew = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
