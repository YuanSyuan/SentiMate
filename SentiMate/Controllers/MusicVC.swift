//
//  MusicVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/10.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import Kingfisher

class MusicVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let musicManager = MusicManager()
    var songs: [StoreItem] = []
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set audio session category. Error: \(error)")
            }
        
        fetchLatestDiaryEntry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchLatestDiaryEntry()
        
    }
    
    func fetchLatestDiaryEntry() {
        let db = Firestore.firestore()
        db.collection("diaries")
            .order(by: "customTime", descending: true)
            .limit(to: 1)
            .getDocuments { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let document = querySnapshot?.documents.first,
                          let data = document.data() as? [String: Any],
                          let emotion = data["emotion"] as? String {
                    self?.callAppleMusicAPI(with: emotion)
                }
            }
    }

    func callAppleMusicAPI(with emotion: String) {
        musicManager.getAPIData(for: emotion) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedSongs):
                    // Handle the fetched songs
                    self?.songs = fetchedSongs
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                    // Handle any errors from the API call
                }
            }
        }
    }


}

extension MusicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath) as? SongCell else {
            fatalError("Could not dequeue DateCell")
        }
        
        let song = songs[indexPath.row]
        
        cell.songLbl.text = song.trackName
        cell.singerLbl.text = song.artistName
        cell.songImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
        return cell
    }
    
    
}

extension MusicVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        let previewUrl = song.previewUrl

            player = AVPlayer(url: previewUrl)
            player?.play()
    }
}

