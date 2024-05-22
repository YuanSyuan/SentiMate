//
//  MusicEntryVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/19.
//

import UIKit
import FirebaseFirestore
import ViewAnimator

class MusicEntryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var firebaseManager = FirebaseManager.shared
    let musicManager = MusicManager()
    var songs: [StoreItem] = []
    var calmSongs: [SoftMusic] = softMusicPlaylist
    var emotion: String?
    var activityIndicator = UIActivityIndicatorView()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureCellSize()
        collectionView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emotion = DiaryManager.shared.diaries.first?.emotion
        callAppleMusicAPI(with: emotion ?? "Neutral")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func configureCellSize() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.minimumInteritemSpacing = 12
        let width = floor(collectionView.bounds.width * 3/5)
        layout?.itemSize = CGSize(width: width, height: width * 2.1)
    }
    
    func callAppleMusicAPI(with emotion: String) {
        self.songs = []
        
        let dispatchGroup = DispatchGroup()
        
        activityIndicator.startAnimating()
        collectionView.isUserInteractionEnabled = false
        
        dispatchGroup.enter()
        musicManager.getAPIData(for: emotion) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedSongs):
                    self?.songs.append(contentsOf: fetchedSongs)
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        musicManager.getMySong(for: "李芫萱") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedSongs):
                    self?.songs.insert(fetchedSongs[1], at: 0)
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.isUserInteractionEnabled = true
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayer",
           let destinationVC = segue.destination as? MusicVC,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destinationVC.songs = []
            destinationVC.topTitleText = playlist[indexPath.row]
            destinationVC.topImg = playlistImage[indexPath.row]
            if indexPath.row == 0 {
                destinationVC.songs = self.songs
            } else {
                destinationVC.songs = self.calmSongs
            }
        }
    }
}

extension MusicEntryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalmMusic", for: indexPath) as? CalmMusicEntryCell else {
            fatalError("Could not dequeue HomeCell")
        }
        
        cell.playlistLbl.text = playlist[indexPath.row]
        cell.descriptionLbl.text = playlistDescription[indexPath.row]
        cell.playlistImg.image = UIImage(named: playlistImage[indexPath.row])
        return cell
        
    }
}

extension MusicEntryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 0)
    }
}
//
//extension MusicEntryVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let viewModel = MusicViewModel()
//        
//        switch indexPath.row {
//        case 0:
//            viewModel.songs = songs
//        default:
//            viewModel.songs = calmSongs
//        }
//    }
//}


