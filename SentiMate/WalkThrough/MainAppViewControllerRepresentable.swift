//
//  MainAppViewControllerRepresentable.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct MainAppViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        // Delaying execution to give SwiftUI view a chance to complete rendering
        DispatchQueue.main.async {
                   if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                       delegate.switchToMainInterface()
                   }
               }
               return UIViewController() // Return a temporary view controller
           }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Handle any updates to the ViewController here if needed
    }
}

