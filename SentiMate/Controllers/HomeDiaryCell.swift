//
//  HomeDiaryCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/12.
//

import UIKit

class HomeDiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emotionImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var emotionLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        containerView.layer.cornerRadius = 40
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.7 // Adjust the opacity as needed
            containerView.layer.shadowRadius = 5 // Adjust the blur radius as needed
            containerView.layer.shadowOffset = CGSize(width: 2, height: 2) // Adjust the offset as needed
            
            // Optimize performance by rasterizing the layer
            containerView.layer.shouldRasterize = true
            containerView.layer.rasterizationScale = UIScreen.main.scale
    }
}
