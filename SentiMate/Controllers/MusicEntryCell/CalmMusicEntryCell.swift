//
//  CalmMusicEntryCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/19.
//

import UIKit

class CalmMusicEntryCell: UICollectionViewCell {
    
    @IBOutlet weak var playlistLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var playlistImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playlistImg.layer.cornerRadius = 20
        playlistImg.clipsToBounds = false
        playlistImg.layer.shadowColor = UIColor.black.cgColor
        playlistImg.layer.shadowOpacity = 0.7
        playlistImg.layer.shadowRadius = 5
        playlistImg.layer.shadowOffset = CGSize(width: 2, height: 2)
       
        playlistImg.layer.shouldRasterize = true
        playlistImg.layer.rasterizationScale = UIScreen.main.scale
    }
}
