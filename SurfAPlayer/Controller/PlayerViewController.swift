//
//  PlayerViewController.swift
//  SurfAPlayer
//
//  Created by Andrei Bogoslovskii on 11.11.2023.
//

import UIKit
import AVFoundation



class PlayerViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var fullTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var songTitle: String!
    var artist: String!
    var player: AVAudioPlayer!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameLabel.text = songTitle
        authorLabel.text = artist
        configPlayer()
        setupTimer()
        player.play()
     }
    
    func configPlayer() {
            if let url = Bundle.main.url(forResource: songTitle, withExtension: "mp3") {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    fullTimeLabel.text = getTimeString(from: player.duration)
                    progressView.progress = 0.0
                } catch {
                    print("Cannot play this song.")
                }
            }
        }
        
        func setupTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.player.isPlaying {
                    self.progressView.progress = Float(self.player.currentTime / self.player.duration)
                    self.currentTimeLabel.text = self.getTimeString(from: self.player.currentTime)
                }
            }
        }

        func getTimeString(from time: TimeInterval) -> String {
            let minutes = Int(time)/60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02i:%02i", minutes, seconds)
        }
    
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
        player.stop()
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
}
