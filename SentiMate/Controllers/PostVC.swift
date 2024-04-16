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

class PostVC: UIViewController {
    
    private let sceneView = ARSCNView()
    private let model = try? VNCoreMLModel(for: CNNEmotions().model)
    
    let captureSession = AVCaptureSession()
    var emotionLabel = UILabel()
    let confirmEmotionBtn = UIButton()
    let saveEmotionBtn = UIButton()
    var currentEmotion: String?
    var isSessionRunning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        saveEmotionBtn.isEnabled = false
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
         
            view.addSubview(sceneView)
            sceneView.delegate = self
            sceneView.showsStatistics = true
            sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
    
    func setupUI() {
    
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabel.textColor = .white
        emotionLabel.textAlignment = .center
        emotionLabel.font = UIFont.systemFont(ofSize: 24)
        emotionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(emotionLabel)
        
        // Set up the button for checking emotion
        saveEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
        saveEmotionBtn.setTitle("儲存", for: .normal)
        saveEmotionBtn.backgroundColor = .white
        saveEmotionBtn.setTitleColor(.darkGray, for: .normal)
        saveEmotionBtn.addTarget(self, action: #selector(saveEmotionTapped), for: .touchUpInside)
        view.addSubview(saveEmotionBtn)
        
        confirmEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
                confirmEmotionBtn.setTitle("確認", for: .normal)
                confirmEmotionBtn.backgroundColor = .gray
                confirmEmotionBtn.addTarget(self, action: #selector(confirmEmotionTapped), for: .touchUpInside)
                view.addSubview(confirmEmotionBtn)
        
            sceneView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(sceneView, at: 0) // Make sure the sceneView is behind all other views
            NSLayoutConstraint.activate([
                sceneView.leftAnchor.constraint(equalTo: view.leftAnchor),
                sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
                // Assuming you want to leave space at the bottom for the label and button
                sceneView.bottomAnchor.constraint(equalTo: emotionLabel.topAnchor, constant: -10),
                sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ])
        
        // Add constraints to label and button
        NSLayoutConstraint.activate([
            emotionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emotionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            emotionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            emotionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            saveEmotionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveEmotionBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveEmotionBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            saveEmotionBtn.heightAnchor.constraint(equalToConstant: 50),
            
            confirmEmotionBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmEmotionBtn.centerYAnchor.constraint(equalTo: saveEmotionBtn.centerYAnchor),
            confirmEmotionBtn.widthAnchor.constraint(equalTo: saveEmotionBtn.widthAnchor),
            confirmEmotionBtn.heightAnchor.constraint(equalTo: saveEmotionBtn.heightAnchor)
        ])
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
                confirmEmotionBtn.setTitle("再拍一次", for: .normal)
            } else {
                isSessionRunning = true
                saveEmotionBtn.isEnabled = false
                let configuration = ARFaceTrackingConfiguration()
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                confirmEmotionBtn.setTitle("確認", for: .normal)
            }
        }
}

// extension: AVCaptureVideoDataOutputSampleBufferDelegate
extension PostVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    // Update the label with the detected emotion
    func updateEmotionLabel(withEmotion emotion: String) {
        currentEmotion = emotion
        DispatchQueue.main.async {
            self.emotionLabel.text = emotion
        }
    }
}

// extension: ARSCNViewDelegate
extension PostVC: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let node = SCNNode(geometry: ARSCNFaceGeometry(device: device))
        node.geometry?.firstMaterial?.fillMode = .lines
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
        } else {
            // Handle the case where the model is nil
        }
    }
    
}
