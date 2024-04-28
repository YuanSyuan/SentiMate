//
//  MainAppViewControllerRepresentable.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct MainAppViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        // Replace "Main" with the name of your storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate the initial view controller of the storyboard, which should be your UINavigationController or UITabBarController
        // Make sure you have set the initial view controller in the storyboard
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Unable to instantiate initial view controller from storyboard.")
        }
        
        // Return the navigation or tab bar controller
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Handle any updates to the ViewController here if needed
    }
}

