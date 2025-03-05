//
//  TermsConditionVC.swift
//  DevioxLinker
//
//  Created by Manthan on 01/03/25.
//

import UIKit

class TermsConditionVC: UIViewController {

    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
