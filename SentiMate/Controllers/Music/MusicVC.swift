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
    
    var topTitleText = ""
    var topImg = ""
    var songs: [Playable] = []
    
    private let musicManager = MusicManager()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var songIndex = 0
    private var playerTimeObserver: Any?
    private var songDuration: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configurePlayerView()
        configureInitialPlayer()
        setupPlayerTimeObserver()
        setupAudioSession()
        setupTopView()
        animateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureInitialPlayer()
        setupPlayerTimeObserver()
        checkMusicIsEnd()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Setup Methods
    // setup player
    func configurePlayerView() {
        configureShadowAndCornerRadius(for: playerView)
        configureShadowAndCornerRadius(for: albumImg)
    }
    
    private func configureShadowAndCornerRadius(for view: UIView) {
        view.layer.cornerRadius = 8
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configureInitialPlayer() {
        let song = songs[0]
        songLbl.text = song.songName
        singerLbl.text = song.artist
        albumImg.image = UIImage(named: song.albumImage)
        player = AVPlayer(url: song.trackURL)
    }
    
    // setup observer to make slider move
    func setupPlayerTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self, let currentTime = self.player?.currentTime().seconds else { return }
            self.updateTimeUI(currentTime: currentTime)
        }
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
    }
    
    private func setupTopView() {
        topTitle.text = topTitleText
        topImage.image = UIImage(named: topImg)
    }
    
    private func animateTableView() {
        let animation = AnimationType.from(direction: .top, offset: 300)
        tableView.animate(animations: [animation], duration: 1)
    }
    
    // MARK: - Player Control Methods
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player?.seek(to: time)
    }
    
    // setup play & pause
    @IBAction func playBtnTapped(_ sender: Any) {
        togglePlayPause()
    }
    
    // play previous song
    @IBAction func backBtnTapped(_ sender: Any) {
        playPreviousSong()
    }
    
    // play next song
    @IBAction func nextBtn(_ sender: Any) {
        playNextSong()
    }
    
    private func togglePlayPause() {
        if player?.timeControlStatus == .paused {
            player?.play()
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player?.pause()
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    private func playPreviousSong() {
        songIndex = (songIndex == 0) ? songs.count - 1 : songIndex - 1
        playSong(at: songIndex)
    }
    
    private func playNextSong() {
        songIndex = (songIndex == songs.count - 1) ? 0 : songIndex + 1
        playSong(at: songIndex)
    }
    
    private func playSong(at index: Int) {
        player?.pause()
        playerItem = AVPlayerItem(url: songs[index].trackURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        
        // UI updates and index updates
        songIndex = index
        playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        songLbl.text = songs[index].songName
        singerLbl.text = songs[index].artist
        albumImg.image = UIImage(named: songs[index].albumImage)
    }
    
    private func updateTimeUI(currentTime: Double) {
        songDuration = songs[songIndex].duration
        timeSlider.maximumValue = Float(songDuration)
        timeSlider.minimumValue = 0
        timeSlider.value = Float(currentTime)
        timeLbl.text = formatTime(fromSeconds: currentTime)
        remainTimeLbl.text = "-\(formatTime(fromSeconds: songDuration - currentTime))"
    }
    
    private func checkMusicIsEnd() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.playNextSong()
        }
    }
    
    private func formatTime(fromSeconds totalSeconds: Double) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        let minutes: Int = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - playlist tableView - UITableViewDataSource, UITableViewDelegate
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
        cell.songImg.kf.setImage(with: URL(string: song.albumImage))
        
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
        
        playSong(at: indexPath.row)
    }
    
}

