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
    var calmSongs: [AudioFile] = []
    
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
    var playerTimeObserver: Any?
    var songDuration: CMTime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configurePlayerView()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
        
        //        fetchLatestDiaryEntry()
        
   
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configurePlayerView()
        //        fetchLatestDiaryEntry()
        checkMusicIsEnd()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
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
                    self?.configurePlayerView()
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                    // Handle any errors from the API call
                }
            }
        }
    }
    
    func configurePlayerView() {
        if songs != [] {
            let song = songs[0]
            
            songLbl.text = song.trackName
            singerLbl.text = song.artistName
            albumImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
            player = AVPlayer(url: song.previewUrl)
            
        } else {
            
            let calmSong = calmSongs[0]
            songLbl.text = calmSong.name
            player = AVPlayer(url: calmSong.localURL)
        }
        
        self.setupPlayerTimeObserver()
    }
    
    // 還要再調整 call observer 的位置
    func setupPlayerTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        
        if songs != [] {
            playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
                guard let self = self, let currentTime = self.player?.currentTime().seconds else { return }
                
                timeSlider.maximumValue = 30
                timeSlider.minimumValue = 0
                timeSlider.value = Float(currentTime)
                timeLbl.text = formatTime(fromSeconds: currentTime)
                remainTimeLbl.text = "-\(formatTime(fromSeconds: 30 - currentTime))"
            }
        } else {
            playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
                guard let self = self, let currentTime = self.player?.currentTime().seconds else { return }
                
                timeSlider.maximumValue = 120
                timeSlider.minimumValue = 0
                timeSlider.value = Float(currentTime)
                timeLbl.text = formatTime(fromSeconds: currentTime)
                remainTimeLbl.text = "-\(formatTime(fromSeconds: 120 - currentTime))"
            }
            
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player?.seek(to: time)
    }
    
    @IBAction func playBtn(_ sender: Any) {
        if player?.timeControlStatus == .paused {
            playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            player?.play()
        } else {
            playBtn.setImage( UIImage(systemName: "play.fill"), for: .normal)
            player?.pause()
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        if songs != [] {
            if songIndex == 0 {
                songIndex = songs.count - 1
                playSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                songIndex -= 1
                playSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
                
            }
        } else {
            if songIndex == 0 {
                songIndex = calmSongs.count - 1
                playCalmSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                songIndex -= 1
                playCalmSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
                
            }
            
        }
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        playNextMusic()
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
    
    func playCalmSong(index: Int) {
        playerItem = AVPlayerItem(url: calmSongs[songIndex].localURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        playBtn.setImage(UIImage(named: "pause.fill"), for: .normal)
        songLbl.text = calmSongs[songIndex].name
        //        singerLbl.text = songs[songIndex].artistName
        //        albumImg.kf.setImage(with: URL(string: "\(songs[songIndex].artworkUrl500)"))
    }
    
    func checkMusicIsEnd() {
        // 偵測是否播放到最後
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.playNextMusic()
        }
    }
    
    func playNextMusic() {
        
        if songs != [] {
            if songIndex == songs.count - 1 {
                songIndex = 0
                playSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                songIndex += 1
                playSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
                
            }
        } else {
            if songIndex == calmSongs.count - 1 {
                songIndex = 0
                playCalmSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                songIndex += 1
                playCalmSong(index: songIndex)
                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
                
            }
            
        }
        
    }
}

extension MusicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songs != [] {
            return  songs.count
        } else {
            return  calmSongs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "song", for: indexPath) as? MusicCell else {
            fatalError("Could not dequeue DateCell")
        }
        
        if songs != [] {
            let song = songs[indexPath.row]
            cell.songLbl.text = song.trackName
            cell.singerLbl.text = song.artistName
            cell.songImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
        } else {
            let song = calmSongs[indexPath.row]
            cell.songLbl.text = song.name
//            cell.singerLbl.text = song.artistName
//            cell.songImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
        }
        
        return cell
    }
    
    
}

extension MusicVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if songs != [] {
            let song = songs[indexPath.row]
            let previewUrl = song.previewUrl
            
            self.songIndex = indexPath.row
            player = AVPlayer(url: previewUrl)
            player?.play()
            
            songLbl.text = song.trackName
            singerLbl.text = song.artistName
            albumImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
            
        } else {
            let song = calmSongs[indexPath.row]
            let previewUrl = song.localURL
            
            self.songIndex = indexPath.row
            player = AVPlayer(url: previewUrl)
            player?.play()
            
            songLbl.text = song.name
//            singerLbl.text = song.artistName
//            albumImg.kf.setImage(with: URL(string: "\(song.artworkUrl500)"))
        }
        
    }
    
    func formatTime(fromSeconds totalSeconds: Double) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        let minutes: Int = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

