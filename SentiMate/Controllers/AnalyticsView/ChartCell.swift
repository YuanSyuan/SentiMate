//
//  ChartCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import UIKit
import SwiftUI

class ChartCell: UITableViewCell {
    let chartLbl = UILabel()
    private var hostingController: UIHostingController<DonutChartView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        contentView.backgroundColor = defaultBackgroundColor
        contentView.addSubview(chartLbl)
        
        chartLbl.translatesAutoresizingMaskIntoConstraints = false
        chartLbl.text = "心情圖"
        chartLbl.font = customFontTitle
        chartLbl.textColor = defaultTextColor
        
        NSLayoutConstraint.activate([
            chartLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chartLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chartLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ])
    }
    
    
    func configureHostingController(with emotionTypes: [EmotionType], parentViewController: UIViewController) {
            let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
            
            if let existingHostingController = hostingController {
                existingHostingController.willMove(toParent: nil)
                existingHostingController.view.removeFromSuperview()
                existingHostingController.removeFromParent()
            }
            
            let newHostingController = UIHostingController(rootView: swiftUIView)
            parentViewController.addChild(newHostingController)
            contentView.addSubview(newHostingController.view)
            newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                newHostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 72),
                newHostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                newHostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                newHostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
            
            newHostingController.didMove(toParent: parentViewController)
            hostingController = newHostingController
        }
    
}
