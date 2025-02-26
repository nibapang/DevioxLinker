//
//  VideoCell.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import UIKit
import AVFoundation

class DevioxVideoCell: UITableViewCell {
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var videoURL: URL?
    var isPlaying: Bool = false
    weak var delegate: DevioxVideoCellDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        stopAndRemovePlayer()
    }
    
    deinit {
        stopAndRemovePlayer()
    }
    func configure(with video: DevioxLarge) {
        self.videoURL = URL(string: video.url)
        setupVideoPlayer()
    }


    func setupVideoPlayer() {
        guard let videoURL = videoURL else { return }

        // Remove existing AVPlayerLayer
        avPlayerLayer?.removeFromSuperlayer()

        // Create AVPlayer
        let avPlayer = AVPlayer(url: videoURL)

        // Create AVPlayerLayer
        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspect
        avPlayerLayer.frame = contentView.bounds

        // Add AVPlayerLayer to contentView's layer
        contentView.layer.addSublayer(avPlayerLayer)

        // Start playing the video
        avPlayer.play()

        // Assign created AVPlayer and AVPlayerLayer to properties
        self.avPlayer = avPlayer
        self.avPlayerLayer = avPlayerLayer

        // Add observer for when the video finishes playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc private func playerDidFinishPlaying() {
        // Show replay option here instead of automatically replaying the video
        delegate?.showReplayAlert()
    }


     func replayVideo() {
        // Seek to the beginning of the video and start playing it again
        avPlayer?.seek(to: .zero)
        avPlayer?.play()
    }


     func stopAndRemovePlayer() {
        avPlayer?.pause()
        avPlayer = nil
        avPlayerLayer?.removeFromSuperlayer()
        avPlayerLayer = nil
        isPlaying = false
        NotificationCenter.default.removeObserver(self)
    }
}

extension DevioxVideoCell {
    func playVideo() {
        avPlayer?.play()
    }
    
    func pauseVideo() {
        avPlayer?.pause()
    }
}
