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

    @IBOutlet weak var hintLbl: UILabel!
    
    var initiallyAnimates = false
    private let animations = [AnimationType.vector((CGVector(dx: 0, dy: 30)))]
    var sceneView: SCNView!
    var sceneEmoji = "Emoticon_40.scn"
    var rotatePanGesture: UIPanGestureRecognizer!
    var dragPanGesture: UIPanGestureRecognizer!
    var longPressGesture: UILongPressGestureRecognizer!
    var initialCameraTransform: SCNMatrix4?
    var initialFieldOfView: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        diaryCollectionView.dataSource = self
        diaryCollectionView.delegate = self
        configureCellSize()
        sceneView = SCNView(frame: CGRect(x: UIScreen.main.bounds.width * 0.55, y: 20, width: 170, height: 170))
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear
        sceneView.scene = SCNScene(named: sceneEmoji)
        view.addSubview(sceneView)
        
        configureGestureRecognizers()
        setupInitialCamera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)
        
        self.firebaseManager.onNewData = { newDiaries in
            DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
            if newDiaries != [] {
                guard let emotion = DiaryManager.shared.diaries.first?.emotion else { return }
                self.setupBasedOnMostCommonEmotion(with: emotion)
                self.hintLbl.text = "快去填寫情緒日記吧"
            } else {
                self.sceneView.scene = SCNScene(named: self.sceneEmoji)
                self.hintLbl.text = ""
            }
        }
        
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            nameLbl.text = savedUsername
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHintLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager.listenForUpdate()
        if DiaryManager.shared.diaries != [] {
            guard let emotion = DiaryManager.shared.diaries.first?.emotion else { return }
            setupBasedOnMostCommonEmotion(with: emotion)
        } else {
            sceneView.scene = SCNScene(named: sceneEmoji)
        }
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
    
    func updateHintLabel() {
        DispatchQueue.main.async {
            if DiaryManager.shared.diaries.isEmpty {
                self.hintLbl.text = "快去填寫情緒日記吧"
            } else {
                self.hintLbl.text = ""
            }
        }
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
    
    func setupBasedOnMostCommonEmotion(with emotionType: String) {
        setupFloatingSceneView(for: emotionType)
    }
    
    func setupFloatingSceneView(for emotion: String) {
        let sceneEmoji: String
            switch emotion {
            case "Happy", "Surprise":
                sceneEmoji = "Emoticon_27.scn"
            case "Neutral":
                sceneEmoji = "Emoticon_40.scn"
            default:
                sceneEmoji = "Emoticon_56.scn"
            }
        
        // Load the 3D scene
        if let scene = SCNScene(named: sceneEmoji) {
            sceneView.scene = scene
        } else {
            print("Failed to load the scene")
        }
    }
    
    func configureGestureRecognizers() {
        let dragPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        dragPanRecognizer.delegate = self
        dragPanRecognizer.minimumNumberOfTouches = 2
        sceneView.addGestureRecognizer(dragPanRecognizer)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        sceneView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let sceneView = gesture.view as? SCNView else { return }
        let scale = gesture.scale
        sceneView.transform = sceneView.transform.scaledBy(x: scale, y: scale)
        gesture.scale = 1.0
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        
        if let view = gestureRecognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        gestureRecognizer.setTranslation(CGPoint.zero, in: gestureRecognizer.view?.superview)
    }
    
    func setupInitialCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        cameraNode.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 0)
        
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        
        initialCameraTransform = cameraNode.transform
        initialFieldOfView = cameraNode.camera?.fieldOfView
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if let cameraNode = sceneView.pointOfView {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            cameraNode.transform = initialCameraTransform ?? SCNMatrix4Identity
            cameraNode.camera?.fieldOfView = initialFieldOfView ?? 60
            SCNTransaction.commit()
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
            let edit = UIAction(title: "編輯", image: UIImage(systemName: "square.and.pencil")) { _ in
                self.editDiaryEntry(at: indexPath)
            }
            
            let delete = UIAction(title: "刪除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteDiaryEntry(at: indexPath)
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

extension HomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DateFormatter {
    static let diaryEntryFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
