//
//  PostVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/10.
//

import UIKit
import AVFoundation
import CoreML
import Vision
import ARKit
import Lottie

class PostVC: UIViewController {
    private let sceneView = ARSCNView()
    private var model: VNCoreMLModel?
    private let titleLbl = UILabel()
    private var textNode: SCNNode?
    private let confirmEmotionBtn = UIButton()
    private let saveEmotionBtn = UIButton()
    private let containerView = UIView()
    private var currentEmotion: String?
    private var isSessionRunning = true
    private var loadingAnimationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupUI()
        setupSceneView()
        
        saveEmotionBtn.isEnabled = false
        confirmEmotionBtn.isEnabled = false
        saveEmotionBtn.addTouchAnimation()
        confirmEmotionBtn.addTouchAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.alpha = 1
    }
    
    // Setup ARKit
    private func setupSceneView() {
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        
        model = ModelManager.shared.model
    }
    
    // Setup UI
    func setupUI() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.text = "識別情緒中"
        titleLbl.textColor = midOrange
        titleLbl.textAlignment = .center
        titleLbl.font = customFontContent
        sceneView.addSubview(titleLbl)
        
        saveEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
        saveEmotionBtn.setImage(UIImage(named: "Send_Orange"), for: .normal)
        saveEmotionBtn.layer.cornerRadius = 10
        saveEmotionBtn.addTarget(self, action: #selector(saveEmotionTapped), for: .touchUpInside)
        view.addSubview(saveEmotionBtn)
        
        confirmEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
        confirmEmotionBtn.setImage(UIImage(named: "Button_Orange_Filled"), for: .normal)
        confirmEmotionBtn.contentMode = .scaleAspectFill
        confirmEmotionBtn.layer.cornerRadius = 30
        confirmEmotionBtn.addTarget(self, action: #selector(confirmEmotionTapped), for: .touchUpInside)
        view.addSubview(confirmEmotionBtn)
        
        loadingAnimationView = .init(name: "Indicator_Orange")
        guard let loadingAnimationView = loadingAnimationView else { return }
        loadingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        loadingAnimationView.contentMode = .scaleAspectFill
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.animationSpeed = 0.5
        sceneView.addSubview(loadingAnimationView)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(sceneView, at: 0)
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140)
        ])
        
        NSLayoutConstraint.activate([
            titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            titleLbl.heightAnchor.constraint(equalToConstant: 50),
            
            saveEmotionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveEmotionBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveEmotionBtn.widthAnchor.constraint(equalToConstant: 50),
            saveEmotionBtn.heightAnchor.constraint(equalToConstant: 50),
            
            confirmEmotionBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmEmotionBtn.centerYAnchor.constraint(equalTo: saveEmotionBtn.centerYAnchor),
            confirmEmotionBtn.widthAnchor.constraint(equalToConstant: 60),
            confirmEmotionBtn.heightAnchor.constraint(equalToConstant: 60),
            
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimationView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor),
            loadingAnimationView.widthAnchor.constraint(equalTo: titleLbl.widthAnchor, multiplier: 0.5),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        showLoadingAnimation()
    }
    
    @objc func saveEmotionTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pushVC = storyboard.instantiateViewController(withIdentifier: "detail") as? PostDetailVC {
            let viewModel = PostDetailViewModel(emotion: currentEmotion ?? "")
            pushVC.viewModel = viewModel
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    @objc func confirmEmotionTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if isSessionRunning == true {
            sceneView.session.pause()
            isSessionRunning = false
            saveEmotionBtn.isEnabled = true
            confirmEmotionBtn.setImage(UIImage(named: "Back_Arrow_Orange32"), for: .normal)
        } else {
            isSessionRunning = true
            saveEmotionBtn.isEnabled = false
            let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            confirmEmotionBtn.setImage(UIImage(named: "Button_Orange_Filled"), for: .normal)
            titleLbl.text = "識別情緒中"
            showLoadingAnimation()
        }
    }
    
    // loading animation play & stop
    private func showLoadingAnimation() {
        loadingAnimationView?.play()
    }
    
    private func hideLoadingAnimation() {
        loadingAnimationView?.stop()
        loadingAnimationView?.removeFromSuperview()
    }
    
    func updateEmotionLabel(withEmotion emotion: String) {
        currentEmotion = emotion
        
        if let emotionEnum = Emotions(rawValue: emotion) {
            let emojiText = Emotions.getMandarinEmotion(emotion: emotionEnum)
            
            DispatchQueue.main.async {
                (self.textNode?.geometry as? SCNText)?.string = emojiText
                self.confirmEmotionBtn.isEnabled = true
                self.titleLbl.text = ""
                self.hideLoadingAnimation()
            }
        }
    }
}

// MARK: - ARSCNViewDelegate
extension PostVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        let textGeometry = SCNText(string: "", extrusionDepth: 4)
        textGeometry.font = customFontSubTitle
        let material = SCNMaterial()
        material.diffuse.contents = midOrange
        textGeometry.materials = [material]

        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(-0.04, 0.11, 0)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)

        node.addChildNode(textNode)
        self.textNode = textNode
    }
    
    // 臉部網格
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let node = SCNNode(geometry: ARSCNFaceGeometry(device: device))
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 0.0,
                                                                 alpha: 0)
        return node
    }
    
    // 更新臉部網格
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        guard let pixelBuffer = sceneView.session.currentFrame?.capturedImage else {
            return
        }
        
        // VNImageRequestHandler
        if let model = self.model {
            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { [weak self] request, _ in
                guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
                DispatchQueue.main.async {
                    if firstResult.confidence > 0.92 {
                        self?.updateEmotionLabel(withEmotion: firstResult.identifier)
                    }
                }
            }])
        } else { }
    }
}