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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureCellSize()
        
//        let animation = AnimationType.from(direction: .left, offset: 300)
//        UIView.animate(views: collectionView.visibleCells, animations: [animation], duration: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLatestDiaryEntry()
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
                    self?.songs = fetchedSongs
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                }
            }
        }
        
        musicManager.getMySong(for: "李芫萱") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedSongs):
                    self?.songs.insert(fetchedSongs[1], at: 0)
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayer",
           let destinationVC = segue.destination as? MusicVC,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destinationVC.songs = []
            destinationVC.calmSongs = []
            if indexPath.row == 0 {
                destinationVC.songs = self.songs
            } else {
                destinationVC.calmSongs = self.calmSongs
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


