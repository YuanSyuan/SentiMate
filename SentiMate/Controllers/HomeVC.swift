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
import TipKit
import Combine

class HomeVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    @IBOutlet weak var hintLbl: UILabel!
    
    // MARK: - Properties
    var firebaseManager = FirebaseManager.shared
    private let animations = [AnimationType.vector((CGVector(dx: 0, dy: 30)))]
    private lazy var sceneView: SCNView = {
            let sceneView = SCNView(frame: CGRect(x: UIScreen.main.bounds.width * 0.55, y: 20, width: 170, height: 170))
            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true
            sceneView.backgroundColor = .clear
            sceneView.scene = SCNScene(named: sceneEmoji)
            return sceneView
        }()
    private var sceneEmoji = "Emoticon_40.scn"
    private var initialCameraTransform: SCNMatrix4?
    private var initialFieldOfView: CGFloat?
    private var emotionFeatureTip = EmotionFeatureTip()
    private var tipObservationTask: Task<Void, Never>?
    private weak var tipView: TipUIView?
    private var viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadUserName()
        viewModel.listenForUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        performAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryVC",
           let destinationVC = segue.destination as? DiaryVC,
           let indexPath = diaryCollectionView.indexPathsForSelectedItems?.first {
            let diary = FirebaseManager.shared.diaries[indexPath.row]
            destinationVC.diary = diary
        }
    }
    
    private func setupUI() {
            navigationController?.navigationBar.isHidden = true
            view.addSubview(sceneView)
            
            diaryCollectionView.dataSource = self
            diaryCollectionView.delegate = self
            configureCellSize()
            configureGestureRecognizers()
            setupInitialCamera()
        }
    
    func configureCellSize() {
        let layout = diaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.minimumInteritemSpacing = 0
        let width = floor((diaryCollectionView.bounds.width - 20) / 2)
        layout?.itemSize = CGSize(width: width, height: width)
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action:  #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        sceneView.addGestureRecognizer(longPressGesture)
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
    
    private func performAnimation() {
           diaryCollectionView.performBatchUpdates({
               UIView.animate(views: self.diaryCollectionView.orderedVisibleCells,
                              animations: animations, options: [.curveEaseInOut], completion: nil)
           }, completion: nil)
       }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.$userName
            .receive(on: RunLoop.main)
            .map { $0 as String? }
            .assign(to: \.text, on: nameLbl)
            .store(in: &cancellables)
        
        viewModel.$diaries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.diaryCollectionView.reloadData()
                if let emotion = self?.viewModel.getMostCommonEmotion() {
                    self?.setupBasedOnMostCommonEmotion(with: emotion)
                } else {
                    self?.sceneView.scene = SCNScene(named: self?.sceneEmoji ?? "Emoticon_40.scn")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$hintText
            .receive(on: RunLoop.main)
            .map { $0 as String? }
            .assign(to: \.text, on: hintLbl)
            .store(in: &cancellables)
    }
    
    // MARK: - Gesture Handlers
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
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if let cameraNode = sceneView.pointOfView {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            cameraNode.transform = initialCameraTransform ?? SCNMatrix4Identity
            cameraNode.camera?.fieldOfView = initialFieldOfView ?? 60
            SCNTransaction.commit()
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            configureTipKit()
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            tipView?.removeFromSuperview()
        }
    }

    // MARK: - Helpers
    func setupBasedOnMostCommonEmotion(with emotionType: String) {
        setupFloatingSceneView(for: emotionType)
    }
    
    func setupFloatingSceneView(for emotion: String) {
        if let emotionEnum = Emotions(rawValue: emotion) {
            let sceneEmoji = Emotions.getSceneEmoji(emotion: emotionEnum)
            if let scene = SCNScene(named: sceneEmoji) {
                sceneView.scene = scene
            } else {
                print("Failed to load the scene")
            }
        }
    }
    
    func configureTipKit() {
        let tipHostingView = TipUIView(emotionFeatureTip)
        tipHostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tipHostingView)
        
        NSLayoutConstraint.activate([
            tipHostingView.topAnchor.constraint(equalTo: sceneView.bottomAnchor),
            tipHostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tipHostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        tipView = tipHostingView
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diary", for: indexPath) as? HomeCell else {
            fatalError("Could not dequeue HomeCell")
        }
        
        let diary = viewModel.diaries[indexPath.row]
        cell.configureCell(with: diary)
        
        return cell
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "diary") as? DiaryVC else { fatalError("Could not find DiaryVC") }
        let diary = viewModel.diaries[indexPath.row]
        viewController.diary = diary
        self.navigationController?.present(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(for: indexPath)
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

