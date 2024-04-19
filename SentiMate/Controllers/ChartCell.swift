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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
