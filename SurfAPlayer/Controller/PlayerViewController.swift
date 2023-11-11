//
//  PlayerViewController.swift
//  SurfAPlayer
//
//  Created by Andrei Bogoslovskii on 11.11.2023.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var fullTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    //MARK: - Properties
    var songTitle: String!
    var artist: String!
    var player: AVAudioPlayer!
    var timer: Timer!
    var currentIndex: Int?
    var songs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = songTitle
        authorLabel.text = artist
        configPlayer()
        setupTimer()
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player.stop()
    }
    
    //MARK: - Alert settings
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Life cycle
    
    func configPlayer() {
        guard let currentIndex = currentIndex, currentIndex < songs.count else { return }
        let songTitle = songs[currentIndex]
        
        guard let url = Bundle.main.url(forResource: songTitle, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            fullTimeLabel.text = getTimeString(from: player.duration)
            progressView.progress = 0.0
        } catch {
            showAlert(with: "Cannot play this song")
        }
        nameLabel.text = songTitle
        authorLabel.text = artist
        
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
    
    //MARK: - Navigation
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let currentIndex = currentIndex, currentIndex > 0 {
            self.currentIndex = currentIndex - 1
            configPlayer()
            player.play()
        } else {
            showAlert(with: "This is the first song, cannot move backward")
        }
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
        if let currentIndex = currentIndex, currentIndex < songs.count - 1 {
            self.currentIndex = currentIndex + 1
            configPlayer()
            player.play()
        } else {
            showAlert(with: "This is the last song, cannot move forward")
        }
    }
}
