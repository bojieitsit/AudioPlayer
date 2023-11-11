//
//  MainViewController.swift
//  SurfAPlayer
//
//  Created by Andrei Bogoslovskii on 11.11.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var songs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        songs = fetchSongs() ?? []
    }
    
    func fetchSongs() -> [String]? {
        guard let assetPaths = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
            return nil
        }
        
        return assetPaths.map { $0.deletingPathExtension().lastPathComponent }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayer" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let playerVC = segue.destination as! PlayerViewController
                playerVC.songTitle = songs[indexPath.row]
                playerVC.artist = "Unknown Artist"  // set your artist here
            }
        }
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let songName = songs[indexPath.row]
        
        cell.textLabel?.text = songName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToPlayer", sender: self)
    }
    
}
