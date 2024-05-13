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
    
    let titleLbl = UILabel()
    var emotionLabel = UILabel()
    let confirmEmotionBtn = UIButton()
    let saveEmotionBtn = UIButton()
    let containerView = UIView()
    var currentEmotion: String?
    var isSessionRunning = true
    
    private var loadingAnimationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
        saveEmotionBtn.isEnabled = false
        confirmEmotionBtn.isEnabled = false
        
        saveEmotionBtn.addTouchAnimation()
        confirmEmotionBtn.addTouchAnimation()
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        
        model = ModelManager.shared.model
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.alpha = 1
    }
    func setupUI() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.text = "現在的情緒"
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        titleLbl.font = customFontContent
        sceneView.addSubview(titleLbl)
        
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabel.textColor = midOrange
        emotionLabel.textAlignment = .center
        emotionLabel.font = customFontTitle
//        emotionLabel.backgroundColor = defaultTextColor.withAlphaComponent(0.5)
//        emotionLabel.layer.cornerRadius = 10
        sceneView.addSubview(emotionLabel)
        
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.backgroundColor = .black
//        sceneView.addSubview(containerView)
        
        saveEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
//        saveEmotionBtn.setTitle("填寫日記", for: .normal)
        
        saveEmotionBtn.setImage(UIImage(named: ""), for: .disabled)
//        saveEmotionBtn.largeContentImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        saveEmotionBtn.backgroundColor = .gray
//        saveEmotionBtn.setTitleColor(defaultBackgroundColor, for: .normal)
//        saveEmotionBtn.setTitleColor(defaultBackgroundColor, for: .disabled)
        saveEmotionBtn.layer.cornerRadius = 10
        saveEmotionBtn.addTarget(self, action: #selector(saveEmotionTapped), for: .touchUpInside)
        view.addSubview(saveEmotionBtn)
        
        confirmEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
//        confirmEmotionBtn.setTitle("確認", for: .normal)
        confirmEmotionBtn.setImage(UIImage(named: "Button_Orange_Filled"), for: .normal)
        confirmEmotionBtn.contentMode = .scaleAspectFill
//        confirmEmotionBtn.largeContentImageInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        confirmEmotionBtn.setTitleColor(defaultBackgroundColor, for: .normal)
//        confirmEmotionBtn.setTitleColor(defaultTextColor, for: .disabled)
//        confirmEmotionBtn.backgroundColor = midOrange
        confirmEmotionBtn.layer.cornerRadius = 30
        confirmEmotionBtn.addTarget(self, action: #selector(confirmEmotionTapped), for: .touchUpInside)
        view.addSubview(confirmEmotionBtn)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(sceneView, at: 0)
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
        
        NSLayoutConstraint.activate([
            titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLbl.bottomAnchor.constraint(equalTo: emotionLabel.topAnchor, constant: -10),
            titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            titleLbl.heightAnchor.constraint(equalToConstant: 50),
            
            emotionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emotionLabel.topAnchor.constraint(equalTo: titleLbl.bottomAnchor),
            emotionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            emotionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            emotionLabel.heightAnchor.constraint(equalToConstant: 50),
            
//            containerView.widthAnchor.constraint(equalToConstant: view.bounds.width),
//            containerView.heightAnchor.constraint(equalToConstant: 120),
//            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            saveEmotionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveEmotionBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveEmotionBtn.widthAnchor.constraint(equalToConstant: 50),
            saveEmotionBtn.heightAnchor.constraint(equalToConstant: 50),
            
//            confirmEmotionBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmEmotionBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmEmotionBtn.centerYAnchor.constraint(equalTo: saveEmotionBtn.centerYAnchor),
            confirmEmotionBtn.widthAnchor.constraint(equalToConstant: 60),
            confirmEmotionBtn.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        showLoadingAnimation()
    }
    
    @objc func saveEmotionTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pushVC = storyboard.instantiateViewController(withIdentifier: "detail") as? PostDetailVC {
            pushVC.emotion = currentEmotion
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    @objc func confirmEmotionTapped() {
        if self.isSessionRunning == true {
            sceneView.session.pause()
            isSessionRunning = false
            saveEmotionBtn.isEnabled = true
            saveEmotionBtn.setImage(UIImage(named: "Send_Orange"), for: .normal)
//            saveEmotionBtn.backgroundColor = midOrange
            confirmEmotionBtn.setImage(UIImage(named: "Back_Arrow_Orange32"), for: .normal)
//            confirmEmotionBtn.setTitle("再拍一次", for: .normal)
//            confirmEmotionBtn.backgroundColor = .gray
        } else {
            isSessionRunning = true
            saveEmotionBtn.isEnabled = false
            saveEmotionBtn.setImage(UIImage(named: ""), for: .disabled)
//            saveEmotionBtn.backgroundColor = .gray
            let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            confirmEmotionBtn.setImage(UIImage(named: "Button_Orange_Filled"), for: .normal)
//            confirmEmotionBtn.setTitle("確認", for: .normal)
//            confirmEmotionBtn.backgroundColor = midOrange
        }
    }
    
    private func showLoadingAnimation() {
        loadingAnimationView = .init(name: "Indicator_Orange")
        loadingAnimationView?.translatesAutoresizingMaskIntoConstraints = false
        loadingAnimationView?.contentMode = .scaleAspectFill
        loadingAnimationView?.loopMode = .loop
        loadingAnimationView?.animationSpeed = 0.5
        
        emotionLabel.addSubview(loadingAnimationView!)
        
        NSLayoutConstraint.activate([
               loadingAnimationView!.centerXAnchor.constraint(equalTo: emotionLabel.centerXAnchor),
               loadingAnimationView!.centerYAnchor.constraint(equalTo: emotionLabel.centerYAnchor),
               loadingAnimationView!.widthAnchor.constraint(equalTo: emotionLabel.widthAnchor, multiplier: 0.5), // Adjust size relative to emotionLabel width
               loadingAnimationView!.heightAnchor.constraint(equalToConstant: 50)  // Keep aspect ratio 1:1 if desired
           ])
        
        loadingAnimationView?.play()
    }
    
    private func hideLoadingAnimation() {
        loadingAnimationView?.stop()
        loadingAnimationView?.removeFromSuperview()
    }
}

// extension: AVCaptureVideoDataOutputSampleBufferDelegate
extension PostVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    func updateEmotionLabel(withEmotion emotion: String) {
        currentEmotion = emotion
        let emojiText: String
        switch emotion {
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
        
        DispatchQueue.main.async {
            UIView.transition(with: self.emotionLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    self.emotionLabel.text = emojiText
                }, completion: nil)
            
            self.confirmEmotionBtn.isEnabled = true
            self.hideLoadingAnimation()
        }
    }
}

// extension: ARSCNViewDelegate
extension PostVC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let node = SCNNode(geometry: ARSCNFaceGeometry(device: device))
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 0.0,
                                                                 alpha: 0)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        guard let pixelBuffer = sceneView.session.currentFrame?.capturedImage else {
            return
        }
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
