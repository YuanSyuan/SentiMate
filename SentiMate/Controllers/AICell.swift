//
//  AICell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import UIKit

class AICell: UITableViewCell {
    // Add custom UI elements here
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        // Initialize and layout your UI components
    }
}

