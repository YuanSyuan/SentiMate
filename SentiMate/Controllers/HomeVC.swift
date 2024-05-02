//
//  HomeVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/12.
//

import UIKit
import FirebaseStorage
import ViewAnimator
import UserNotifications
import SceneKit

class HomeVC: UIViewController {
    
    var firebaseManager = FirebaseManager.shared
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    
    var initiallyAnimates = false
    
    private let animations = [AnimationType.vector((CGVector(dx: 0, dy: 30)))]
    
    var sceneView: SCNView!
    
    var floatingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        diaryCollectionView.dataSource = self
        diaryCollectionView.delegate = self
        configureCellSize()
        createNotificationContent ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)
        
        self.firebaseManager.onNewData = { newDiaries in
            DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
        }
        
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            nameLbl.text = savedUsername
        }
        
        setupFloatingSceneView()
        configureGestureRecognizers()
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
    
    func setupFloatingSceneView() {
            // Initialize the draggable floating view
            floatingView = DraggableFloatingView(frame: CGRect(x: 20, y: 100, width: 300, height: 300))
        floatingView.backgroundColor = .red
            
            // Initialize and add SCNView
            sceneView = SCNView(frame: CGRect(x: 10, y: 10, width: 150, height: 150))
            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true
            sceneView.backgroundColor = .clear
            floatingView.addSubview(sceneView)
            
            // Add floating view to the main view
            view.addSubview(floatingView)
            
            // Load the 3D scene
            if let scene = SCNScene(named: "Emoticon_56.scn") {
                sceneView.scene = scene
            } else {
                print("Failed to load the scene")
            }
        }
        
        func configureGestureRecognizers() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
            floatingView.addGestureRecognizer(panGesture)
        }
        
        @objc func handleDrag(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: view)
            if gesture.state == .changed {
                gesture.view?.center.x += translation.x
                gesture.view?.center.y += translation.y
                gesture.setTranslation(.zero, in: view)
            }
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

extension HomeVC {
    func createNotificationContent () {
            let content = UNMutableNotificationContent()    // 建立內容透過指派content來取得UNMutableNotificationContent功能
            content.title = "今天過得如何呢？"                 // 推播標題
            content.subtitle = "不管有什麼樣的情緒"            // 推播副標題
            content.body = "在休息之前，把今天好好的記錄下來吧！"        // 推播內文
            content.badge = 1                               // app的icon右上角跳出的紅色數字數量 line 999的那個
            content.sound = UNNotificationSound.defaultCritical     //推播的聲音
        
        var dateComponents = DateComponents()
               dateComponents.hour = 17    // 21:00 hours
               dateComponents.minute = 45   // 0 minutes

            
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)   //設定透過時間來完成推播，另有日期地點跟遠端推播
            let uuidString = UUID().uuidString              //建立UNNotificationRequest所需要的ID
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) //向UNUserNotificationCenter新增註冊這一則推播
        }
}

extension DateFormatter {
    static let diaryEntryFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
