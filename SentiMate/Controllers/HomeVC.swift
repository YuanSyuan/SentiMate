//
//  HomeVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/12.
//

import UIKit
import FirebaseStorage
import ViewAnimator

class HomeVC: UIViewController {
    
    var firebaseManager = FirebaseManager.shared
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
    var initiallyAnimates = false
    
    private let animations = [AnimationType.vector((CGVector(dx: 0, dy: 30)))]
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private var items = [Any?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryCollectionView.dataSource = self
        diaryCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)
        
        self.firebaseManager.onNewData = { newDiaries in
                    DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
                }
        
        configureCellSize()
        
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            nameLbl.text = savedUsername
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager.listenForUpdate()
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated);
//        super.viewWillDisappear(animated)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
    
    @objc private func diariesDidUpdate() {
           diaryCollectionView.reloadData()
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryVC",
           let destinationVC = segue.destination as? DiaryVC,
            let indexPath = diaryCollectionView.indexPathsForSelectedItems?.first {
            let diary = DiaryManager.shared.diaries[indexPath.row]
            destinationVC.diary = diary
        }
    }
    
    func configureCellSize() {
        let layout = diaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.minimumInteritemSpacing = 0
        let width = floor((diaryCollectionView.bounds.width - 20) / 2)
        layout?.itemSize = CGSize(width: width, height: width)
    }
}

extension HomeVC: UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DiaryManager.shared.diaries.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diary", for: indexPath) as? HomeDiaryCell else {
        fatalError("Could not dequeue HomeDiaryCell")
    }
    var diary = DiaryManager.shared.diaries[indexPath.row]
    
    let emojiText: String
    switch diary.emotion {
        case "Fear":
        emojiText = "緊張"
        case "Sad":
        emojiText = "難過"
        case "Neutral":
        emojiText = "普通"
        case "Happy":
        emojiText = "開心"
        case "Surprise":
        emojiText = "驚喜"
        case "Angry":
        emojiText = "生氣"
        default:
        emojiText = "厭惡"
        }
    
    cell.dateLbl.text = "\(diary.customTime)"
    cell.categoryLbl.text = buttonTitles[diary.category]
    cell.emotionLbl.text = emojiText
    cell.emotionImg.image = UIImage(named: diary.emotion)
    
    return cell
    }
}
 

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       guard let viewController = UIStoryboard(name: "Main", bundle: .main)
        .instantiateViewController(identifier: "diary") as? DiaryVC else { fatalError("Could not find DiaryVC") }
        let diary = DiaryManager.shared.diaries[indexPath.row]
        viewController.diary = diary
        self.navigationController?.pushViewController(viewController, animated: true)
    }
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = collectionView.cellForItem(at: indexPath) as? HomeDiaryCell {
//                cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
//                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = collectionView.cellForItem(at: indexPath) as? HomeDiaryCell {
//                cell.contentView.transform = .identity
//                cell.contentView.backgroundColor = .clear
//            }
//        }
//    }
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
    }
}

extension HomeVC: CSCardViewPresenter {
    var cardViewPresenterCard: UIView? {
        
        return self.view // Return the view that represents the start of your transition
    }
}
