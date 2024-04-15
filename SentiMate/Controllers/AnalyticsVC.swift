//
//  AnalyticsVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/10.
//
//
import UIKit
import SwiftUI
import Charts

class AnalyticsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiate your SwiftUI view
        let emotionTypes = DiaryManager.shared.getEmotionTypes()

               // Instantiate your SwiftUI view with emotion types
        let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
        
        // Create a hosting controller with swiftUIView as the root view
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        
        // Add the SwiftUI view to the view controller's view hierarchy
        view.addSubview(hostingController.view)
        
        // Set up constraints for the hosting controller's view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        hostingController.view.frame = view.bounds
        
        // Activate constraints
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Notify the hosting controller that it has been moved to the current view controller
        hostingController.didMove(toParent: self)
    }
}


