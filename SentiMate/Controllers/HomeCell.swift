//
//  HomeCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/12.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emotionImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var emotionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.7
            containerView.layer.shadowRadius = 5
            containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            containerView.layer.shouldRasterize = true
            containerView.layer.rasterizationScale = UIScreen.main.scale
    }
}
