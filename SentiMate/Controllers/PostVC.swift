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
    let saveEmotionBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
         
            view.addSubview(sceneView)
            sceneView.delegate = self
            sceneView.showsStatistics = true
            sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
    
    func setupUI() {
        // Set up the label for emotion display
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabel.textColor = .white
        emotionLabel.textAlignment = .center
        emotionLabel.font = UIFont.systemFont(ofSize: 24)
        emotionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(emotionLabel)
        
        // Set up the button for checking emotion
        saveEmotionBtn.translatesAutoresizingMaskIntoConstraints = false
        saveEmotionBtn.setTitle("Check Emotion", for: .normal)
        saveEmotionBtn.backgroundColor = .blue
        saveEmotionBtn.addTarget(self, action: #selector(saveEmotionTapped), for: .touchUpInside)
        view.addSubview(saveEmotionBtn)
        
        // Set up the sceneView constraints to not cover the entire screen
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
            
            saveEmotionBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveEmotionBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveEmotionBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            saveEmotionBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func saveEmotionTapped() {
        // Placeholder for action to check emotion
        // You would trigger the emotion check here
        print("Check emotion button tapped")
    }
}

// extension: AVCaptureVideoDataOutputSampleBufferDelegate
extension PostVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    // Update the label with the detected emotion
    func updateEmotionLabel(withEmotion emotion: String) {
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
