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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        diaryCollectionView.dataSource = self
        diaryCollectionView.delegate = self
        configureCellSize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)
        
        self.firebaseManager.onNewData = { newDiaries in
            DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
        }
        
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            nameLbl.text = savedUsername
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        diaryCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager.listenForUpdate()
    }
    
    private func animateInitialLoad() {
        if initiallyAnimates {
            diaryCollectionView.reloadData()
            diaryCollectionView.performBatchUpdates({
                UIView.animate(views: self.diaryCollectionView.visibleCells,
                               animations: animations, completion: {
                })
            }, completion: nil)
        }
    }
    
    @objc private func diariesDidUpdate() {
        diaryCollectionView.reloadData()
        diaryCollectionView.performBatchUpdates({
            UIView.animate(views: self.diaryCollectionView.orderedVisibleCells,
                           animations: animations, options: [.curveEaseInOut], completion: nil)
        }, completion: nil)
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
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.diaryCollectionView)
        let indexPath = self.diaryCollectionView.indexPathForItem(at: point)
        if let index = indexPath {
            print(index.row)}
        else {
            print("Could not find index path")
        }
    }}

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
        self.navigationController?.present(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(for: indexPath)
    }
    
    func configureContextMenu(for indexPath: IndexPath) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
                self.editDiaryEntry(at: indexPath)
                print("Edit action for item at \(indexPath.row)")
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteDiaryEntry(at: indexPath)
                print("Delete action for item at \(indexPath.row)")
            }
            return UIMenu(title: "Options", children: [edit, delete])
        }
    }
    
    func editDiaryEntry(at indexPath: IndexPath) {
        // Fetch the diary
        let diary = DiaryManager.shared.diaries[indexPath.row]
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detail") as? PostDetailVC {
            viewController.documentID = diary.documentID
            viewController.emotion = diary.emotion
            viewController.selectedCategoryIndex = diary.category
            viewController.selectedDate = DateFormatter.diaryEntryFormatter.date(from: diary.customTime)
            viewController.userInput = diary.content
            navigationController?.pushViewController(viewController, animated: true)
            print(viewController.selectedDate)
        }
    }
    
    func deleteDiaryEntry(at indexPath: IndexPath) {
        let diary = DiaryManager.shared.diaries[indexPath.row]
        
        firebaseManager.deleteDiaryEntry(documentID: diary.documentID) { success, error in
            if success {
            } else if let error = error {
                print("Error deleting diary entry: \(error.localizedDescription)")
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
    }
}

extension DateFormatter {
    static let diaryEntryFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
