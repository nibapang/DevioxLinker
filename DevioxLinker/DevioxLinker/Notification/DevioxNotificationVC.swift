//
//  NotificationVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit

class DevioxNotificationVC: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    
    var arrNotifications: [String] = [
    "Search on Search post screen to find specific post.",
    "Double Tap On Post to like it.",
    "share post by share button.",
    "tap on plust icon to add your post.",
    "view your post on your profile.",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl.delegate = self
        tbl.dataSource = self
        
    }
    
    
}

extension DevioxNotificationVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbl.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)as! DevioxNotificationCell
        cell.lbl.text = arrNotifications[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let act = UIContextualAction(style: .destructive, title: "DELETE") { _, _, _ in
            
            print("Swiped.")
            self.arrNotifications.remove(at: indexPath.item)
            self.tbl.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        let conf = UISwipeActionsConfiguration(actions: [act])
        
        return conf
    }
}
