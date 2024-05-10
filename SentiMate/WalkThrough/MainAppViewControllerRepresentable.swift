//
//  MainAppViewControllerRepresentable.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct MainAppViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
       
        DispatchQueue.main.async {
                   if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                       delegate.switchToMainInterface()
                   }
               }
               return UIViewController() 
           }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Handle any updates to the ViewController here if needed
    }
}

