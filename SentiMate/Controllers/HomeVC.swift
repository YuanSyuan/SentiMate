//
//  HomeVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/12.
//


import UIKit
import FirebaseStorage

class HomeVC: UIViewController {
    
    var firebaseManager = FirebaseManager.shared
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
//    var diaries: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryCollectionView.dataSource = self
        diaryCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)

                firebaseManager.onNewData = { newDiaries in
                    DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
                }
        
//        configureCellSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager.listenForUpdate()
    }
    
    @objc private func diariesDidUpdate() {
           diaryCollectionView.reloadData()
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryVC",
           let destinationVC = segue.destination as? DiaryVC,
            let indexPath = diaryCollectionView.indexPathsForSelectedItems?.first{
            let diary = DiaryManager.shared.diaries[indexPath.row]
            destinationVC.diary = diary
        }
    }
//    
//    func configureCellSize() {
//            let layout = diaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//            layout?.estimatedItemSize = .zero
//            layout?.minimumInteritemSpacing = 0
//            let width = floor((diaryCollectionView.bounds.width - 16) / 2)
//            let height = width * 1.3
//            layout?.itemSize = CGSize(width: width, height: height)
//        }
    
    
}

extension HomeVC: UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DiaryManager.shared.diaries.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diary", for: indexPath) as? HomeDiaryCell else {
        fatalError("Could not dequeue HomeDiaryCell")
    }
    let diary = DiaryManager.shared.diaries[indexPath.row]
    cell.dateLbl.text = "\(diary.customTime)"
    cell.categoryLbl.text = buttonTitles[diary.category]
    cell.emotionLbl.text = diary.emotion
 
    return cell
    }
    
}
 

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 24) / 2
        let height = width * 1.2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}
