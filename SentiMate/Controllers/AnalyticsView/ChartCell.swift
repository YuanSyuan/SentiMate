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
    var hostingController: UIHostingController<AnyView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = defaultBackgroundColor
//
//        containerView.clipsToBounds = false
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOpacity = 0.7
//        containerView.layer.shadowRadius = 5
//        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
//
//        containerView.layer.shouldRasterize = true
//        containerView.layer.rasterizationScale = UIScreen.main.scale
//
        contentView.addSubview(chartLbl)
//
        chartLbl.translatesAutoresizingMaskIntoConstraints = false
        chartLbl.text = "心情圖"
        chartLbl.font = customFontTitle
        chartLbl.textColor = defaultTextColor
        
        NSLayoutConstraint.activate([
            chartLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chartLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chartLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
//            chartLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
