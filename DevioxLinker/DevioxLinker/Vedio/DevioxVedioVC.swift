//
//  VedioVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit
import AVFoundation

class DevioxVedioVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var videos: [DevioxLarge] = []
    var visibleIndexPaths: [IndexPath] {
        return tableView.indexPathsForVisibleRows ?? []
    }
    var arrVideoCategory = ["nature+vertical", "sky+vertical", "road+vertical"]//, "car", "bike", "Nature", "Water", "Trip"]
    var currentPlayingIndexPath: IndexPath?
    var strCategory = String()
    var isLoadingVideos = false // Flag to track whether videos are currently being loaded
    var currentPage = 1 // Track the current page of loaded videos
    let videosPerPage = 3
    var txtStr = String()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        strCategory = arrVideoCategory.randomElement() ?? "nature+vertical"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DevioxVideoCell.self, forCellReuseIdentifier: "VideoCell")

        let pageToFetch = 1
         
         fetchVideos(for: pageToFetch) { [weak self] newVideos in
             DispatchQueue.main.async {
                 self?.videos = newVideos
                 self?.tableView.reloadData()
             }
         }
        addLongPressGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        strCategory = arrVideoCategory.randomElement() ?? "nature+vertical"
    }
    // MARK: - Functions

    func addLongPressGesture() {
          let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
          tableView.addGestureRecognizer(longPress)
      }
      
      @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
          if gestureRecognizer.state == .began {
              let touchPoint = gestureRecognizer.location(in: tableView)
              if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                  showActionSheet(for: indexPath)
              }
          }
      }
      
      func showActionSheet(for indexPath: IndexPath) {
          let alert = UIAlertController(title: "Actions", message: "Choose an option", preferredStyle: .actionSheet)
          
          let reportAction = UIAlertAction(title: "Report", style: .destructive) { _ in
              self.showReportAlert()
              print("Reported video at index: \(indexPath.row)")
          }
          
          let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
              self.showBlockAlert()
              print("Blocked video at index: \(indexPath.row)")
          }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          
          alert.addAction(reportAction)
          alert.addAction(blockAction)
          alert.addAction(cancelAction)
          
          present(alert, animated: true, completion: nil)
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

       func fetchVideos(for page: Int, completion: @escaping ([DevioxLarge]) -> Void) {
           guard let url = URL(string: "https://pixabay.com/api/videos/?key=41590966-3b6d86129f917e3f420f0b383&q=\(strCategory)&page=\(page)") else {
               return
           }

           URLSession.shared.dataTask(with: url) { (data, response, error) in
               guard let data = data, error == nil else {
                   // Handle error
                   completion([])
                   return
               }

               do {
                   let decoder = JSONDecoder()
                   let videoModel = try decoder.decode(DevioxVideoModel.self, from: data)

                   // Extract video URLs
                   let newVideos = videoModel.hits.compactMap { $0.videos.small }
                   completion(newVideos)
               } catch {
                   print("Error decoding videos: \(error)")
                   completion([])
               }
           }.resume()
       }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! DevioxVideoCell
        
        let video = videos[indexPath.row]
        cell.configure(with: video)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "VideoDownloadVC") as? VideoDownloadVC {
//            vc.url = videos[indexPath.row].url
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? DevioxVideoCell else { return }
        videoCell.avPlayer?.pause()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? DevioxVideoCell else { return }
        videoCell.avPlayer?.play()
    }
    
    // MARK: - Video Playback

    func updateVideoPlayback() {
        let visibleCells = tableView.visibleCells.compactMap { $0 as? DevioxVideoCell }
        
        for cell in visibleCells {
            let cellRect = tableView.rectForRow(at: tableView.indexPath(for: cell)!)
            let intersect = cellRect.intersection(tableView.bounds)
            let visibleHeight = intersect.height
            
            if visibleHeight >= cell.contentView.bounds.height * 0.5 {
                if let indexPath = tableView.indexPath(for: cell), currentPlayingIndexPath != indexPath {
                    playVideo(at: indexPath)
                }
            } else {
                cell.pauseVideo()
            }
        }
    }

    func playVideo(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DevioxVideoCell {
            cell.playVideo()
            currentPlayingIndexPath = indexPath
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateVideoPlayback()
    }
    
     func showReplayOption() {
        // Show a replay button or any other UI element to allow the user to replay the video
        // For example, you can display a UIAlertController with an option to replay the video
        let alertController = UIAlertController(title: "Video Finished", message: "Do you want to replay the video?", preferredStyle: .alert)
        
        let replayAction = UIAlertAction(title: "Replay", style: .default) { [weak self] _ in
            // Replay the video when the user chooses to replay
            let cell = UITableViewCell()
            guard let videoCell = cell as? DevioxVideoCell else { return }
            videoCell.replayVideo()
        }
        alertController.addAction(replayAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
