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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(withEmotion emotion: String) {
        if let emotionEnum = Emotions(rawValue: emotion) {
            let emojiText = Emotions.getMandarinEmotion(emotion: emotionEnum)
            self.emotionLbl.text = emojiText
        }
    }
}


