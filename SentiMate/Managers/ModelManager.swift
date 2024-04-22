//
//  ModelManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/22.
//

import Foundation
import CoreML
import Vision

class ModelManager {
    static let shared = ModelManager()
    private(set) var model: VNCoreMLModel?
    
    private init() {}
    
    func loadModelInBackground(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let model = try VNCoreMLModel(for: CNNEmotions().model)
                DispatchQueue.main.async {
                    self?.model = model
                    completion?()
                }
            } catch {
                print("Failed to load CoreML model: \(error)")
            }
        }
    }
}

