//
//  MainAppViewControllerRepresentable.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct MainAppViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Unable to instantiate initial view controller from storyboard.")
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Handle any updates to the ViewController here if needed
    }
}

