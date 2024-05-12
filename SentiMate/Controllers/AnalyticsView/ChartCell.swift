//
//  ChartCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import UIKit
import SwiftUI

class ChartCell: UITableViewCell {
    let containerView = UIView()
    var hostingController: UIHostingController<AnyView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        containerView.backgroundColor = defaultTextColor
//        containerView.layer.cornerRadius = 20
//        
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
//        contentView.addSubview(containerView)
//        
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
