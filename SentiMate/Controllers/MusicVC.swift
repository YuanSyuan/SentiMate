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
   
    
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var singerLbl: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var remainTimeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var songIndex = 0
    
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

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player?.seek(to: time)
    }
    
    @IBAction func playBtn(_ sender: Any) {
        if player?.timeControlStatus == .paused {
            playBtn.imageView?.image = UIImage(named: "play.fill")
                    player?.play()
                } else {
                    playBtn.imageView?.image = UIImage(named: "pause.fill")
                    player?.pause()
                }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if songIndex == 0 {
                    songIndex = songs.count - 1
            playSong(index: songIndex)
        } else {
                    songIndex -= 1
            playSong(index: songIndex)
              
                }
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if songIndex == songs.count - 1 {
                    songIndex = 0
            playSong(index: songIndex)
        } else {
                    songIndex += 1
            playSong(index: songIndex)
              
                }
    }
    
    func playSong(index: Int) {
            playerItem = AVPlayerItem(url: songs[songIndex].previewUrl)
            player?.replaceCurrentItem(with: playerItem)
            player?.play()
            playBtn.setImage(UIImage(named: "pause.fill"), for: .normal)
            songLbl.text = songs[songIndex].trackName
            singerLbl.text = songs[songIndex].artistName
            albumImg.kf.setImage(with: URL(string: "\(songs[songIndex].artworkUrl500)"))
        }
}

extension MusicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath) as? MusicCell else {
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
        
        self.songIndex = indexPath.row
        player = AVPlayer(url: previewUrl)
          
        songLbl.text = song.trackName
        singerLbl.text = song.artistName
        albumImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
        
    }
    
    
    
    
   
}

