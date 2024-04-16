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
        
        containerView.layer.cornerRadius = 10
    }
}
