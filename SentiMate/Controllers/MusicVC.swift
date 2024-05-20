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
import ViewAnimator

class MusicVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var topTitle: UILabel!
    
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var singerLbl: UILabel!
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var remainTimeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    let musicManager = MusicManager()
    var songs: [Playable] = []
//    var calmSongs: [SoftMusic] = []
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var songIndex = 0
    var playerTimeObserver: Any?
    var songDuration: CMTime?
    
    // refactor
//    let viewModel = MusicViewModel()
    var playerClass = MusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configurePlayerView()
//        setupPlayerTimeObserver()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
        
        // 改去 didselectitem 寫
//        if songs != [] {
//            topTitle.text = playlist[0]
//        } else {
//            topTitle.text = playlist[1]
//        }
//        
//        if songs != [] {
//            topImage.image = UIImage(named: playlistImage[0])
//        } else {
//            topImage.image = UIImage(named: playlistImage[1])
//        }
        
        
        // 拉下去寫
        playerView.layer.cornerRadius = 8
        playerView.clipsToBounds = false
        playerView.layer.shadowColor = UIColor.black.cgColor
        playerView.layer.shadowOpacity = 0.7
        playerView.layer.shadowRadius = 5
        playerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        playerView.layer.shouldRasterize = true
        playerView.layer.rasterizationScale = UIScreen.main.scale
        
        albumImg.layer.cornerRadius = 8
        albumImg.clipsToBounds = false
        albumImg.layer.shadowColor = UIColor.black.cgColor
        albumImg.layer.shadowOpacity = 0.7
        albumImg.layer.shadowRadius = 5
        albumImg.layer.shadowOffset = CGSize(width: 2, height: 2)
        albumImg.layer.shouldRasterize = true
        albumImg.layer.rasterizationScale = UIScreen.main.scale
        
        let animation = AnimationType.from(direction: .top, offset: 300)
        tableView.animate(animations: [animation], duration: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configurePlayerView()
//        setupPlayerTimeObserver()
        checkMusicIsEnd()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func configurePlayerView() {
        let song = songs[0]
        songLbl.text = song.songName
        singerLbl.text = song.artist
        albumImg.image = UIImage(named: song.albumImage)
    }
    
    // 還要再調整 call observer 的位置
//    func setupPlayerTimeObserver() {
//        let interval = CMTime(seconds: 1, preferredTimescale: 1)
//        
//        if songs != [] {
//            playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
//                guard let self = self, let currentTime = self.player?.currentTime().seconds else { return }
//                
//                timeSlider.maximumValue = 30
//                timeSlider.minimumValue = 0
//                timeSlider.value = Float(currentTime)
//                timeLbl.text = formatTime(fromSeconds: currentTime)
//                remainTimeLbl.text = "-\(formatTime(fromSeconds: 30 - currentTime))"
//            }
//        } else {
//            playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
//                guard let self = self, let currentTime = self.player?.currentTime().seconds else { return }
//                
//                timeSlider.maximumValue = 120
//                timeSlider.minimumValue = 0
//                timeSlider.value = Float(currentTime)
//                timeLbl.text = formatTime(fromSeconds: currentTime)
//                remainTimeLbl.text = "-\(formatTime(fromSeconds: 120 - currentTime))"
//            }
//        }
//    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player?.seek(to: time)
    }
    
    @IBAction func playBtnTapped(_ sender: Any) {
        if player?.timeControlStatus == .paused {
            player?.play()
            playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player?.pause()
            playBtn.setImage( UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
//    @IBAction func backBtnTapped(_ sender: Any) {
//        if songs != [] {
//            if songIndex == 0 {
//                songIndex = songs.count - 1
//                playSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            } else {
//                songIndex -= 1
//                playSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            }
//        } else {
//            if songIndex == 0 {
//                songIndex = calmSongs.count - 1
//                playCalmSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            } else {
//                songIndex -= 1
//                playCalmSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            }
//        }
//    }
    
    @IBAction func nextBtn(_ sender: Any) {
//        playNextMusic()
    }
    
    func playSong(index: Int) {
        player?.pause()
        playerItem = AVPlayerItem(url: songs[songIndex].trackURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        playBtn.setImage(UIImage(named: "pause.fill"), for: .normal)
        songLbl.text = songs[songIndex].songName
        singerLbl.text = songs[songIndex].artist
        albumImg.image = UIImage(named: songs[songIndex].albumImage)
    }
//    
//    func playCalmSong(index: Int) {
//        player?.pause()
//        guard let url = URL(string: calmSongs[index].url) else { return }
//        playerItem = AVPlayerItem(url: url)
//        player?.replaceCurrentItem(with: playerItem)
//        player?.play()
//        playBtn.setImage(UIImage(named: "pause.fill"), for: .normal)
//        songLbl.text = calmSongs[songIndex].name
//        albumImg.image = UIImage(named: calmSongs[songIndex].image)
//    }
    
    func checkMusicIsEnd() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
//            self.playNextMusic()
        }
    }
    
//    func playNextMusic() {
//        if songs != [] {
//            if songIndex == songs.count - 1 {
//                songIndex = 0
//                playSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            } else {
//                songIndex += 1
//                playSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            }
//        } else {
//            if songIndex == calmSongs.count - 1 {
//                songIndex = 0
//                playCalmSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            } else {
//                songIndex += 1
//                playCalmSong(index: songIndex)
//                playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//            }
//        }
//    }
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
        cell.songLbl.text = song.songName
        cell.singerLbl.text = song.artist
        cell.songImg.image = UIImage(named: song.albumImage)
                
        return cell
    }
}

extension MusicVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animation = AnimationType.zoom(scale: 0.95)
        if let cell = tableView.cellForRow(at: indexPath) as? MusicCell {
            cell.contentView.animate(animations: [animation], duration: 0.5)
        }
        
        player?.pause()
       
        let song = songs[indexPath.row]
        songLbl.text = song.songName
        singerLbl.text = song.artist
        albumImg.image = UIImage(named: song.albumImage)
        
        playSong(index: indexPath.row)
        
        player?.play()
        playBtn.setImage( UIImage(systemName: "pause.fill"), for: .normal)
//        setupPlayerTimeObserver()
    }
    
    func formatTime(fromSeconds totalSeconds: Double) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        let minutes: Int = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

