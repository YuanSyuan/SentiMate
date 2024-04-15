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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager.listenForUpdate()
    }
    
    @objc private func diariesDidUpdate() {
           diaryCollectionView.reloadData()
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
    let diary = DiaryManager.shared.diaries[indexPath.row]
    cell.dateLbl.text = "\(diary.customTime)"
    cell.categoryLbl.text = buttonTitles[diary.category]
    cell.emotionLbl.text = diary.emotion
 
    return cell
    }
    
}
 

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 150
        let height = width * (300/164)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
