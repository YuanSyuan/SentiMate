//
//  ChartCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import UIKit
import SwiftUI

class ChartCell: UITableViewCell {
    var hostingController: UIHostingController<AnyView>?
//            didSet {
//                if let hcView = hostingController?.view {
//                    hcView.removeFromSuperview() // Remove from old content view
//                    hcView.translatesAutoresizingMaskIntoConstraints = false
//                    contentView.addSubview(hcView)
//                    NSLayoutConstraint.activate([
//                        hcView.topAnchor.constraint(equalTo: contentView.topAnchor),
//                        hcView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                        hcView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                        hcView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//                    ])
//                }
//            }
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
