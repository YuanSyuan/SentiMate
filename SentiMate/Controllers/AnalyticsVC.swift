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
    private var tableView: UITableView!
    private var hostingController: UIHostingController<DonutChartView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AICell.self, forCellReuseIdentifier: "AICell")
        tableView.register(ChartCell.self, forCellReuseIdentifier: "ChartCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
  
  }


extension AnalyticsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2  // Since you mentioned two cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AICell", for: indexPath) as? AICell else {
                fatalError("Could not dequeue AICell") }
                    // Configure the cell
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else {
                        fatalError("Could not dequeue ChartCell") }
                    
                    let emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: .allTime)
                    let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
                    // If we already have a hosting controller, just update the SwiftUI view
                    if let hostingController = hostingController {
                        hostingController.rootView = swiftUIView
                    } else {
                        // Create the hosting controller with the SwiftUI view
                        let newHostingController = UIHostingController(rootView: swiftUIView)
                        cell.contentView.addSubview(newHostingController.view)
                        newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            newHostingController.view.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor),
                            newHostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                            newHostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                            newHostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.bottomAnchor)
                        ])
                        
                        newHostingController.didMove(toParent: self)
                        // Keep a reference to the hosting controller
                        hostingController = newHostingController
                    }
                    return cell
                }
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return view.bounds.height
            }
    }
}



