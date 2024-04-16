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
    
    private var hostingController: UIHostingController<DonutChartView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDonutChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDonutChart()
    }
    
    private func loadDonutChart() {
        let emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: .allTime)
            let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
            
            // If we already have a hosting controller, just update the SwiftUI view
            if let hostingController = hostingController {
                hostingController.rootView = swiftUIView
            } else {
                // Create the hosting controller with the SwiftUI view
                let newHostingController = UIHostingController(rootView: swiftUIView)
                addChild(newHostingController)
                view.addSubview(newHostingController.view)
                newHostingController.view.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    newHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    newHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    newHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    newHostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
                
                newHostingController.didMove(toParent: self)
                // Keep a reference to the hosting controller
                hostingController = newHostingController
            }
        }
}


