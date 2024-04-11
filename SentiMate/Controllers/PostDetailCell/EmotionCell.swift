//
//  EmotionCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

class EmotionCell: UITableViewCell {

    @IBOutlet weak var emotionLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withEmotion emotion: String) {
            self.emotionLbl.text = emotion
        }

}
