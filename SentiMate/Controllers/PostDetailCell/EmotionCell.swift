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
        
        let emojiText: String
        switch emotion {
            case "Fear":
            emojiText = "緊張"
            case "Sad":
            emojiText = "難過"
            case "Neutral":
            emojiText = "普通"
            case "Happy":
            emojiText = "開心"
            case "Surprise":
            emojiText = "驚喜"
            case "Angry":
            emojiText = "生氣"
            default:
            emojiText = "厭惡"
            }
        
        self.emotionLbl.text = emojiText
        }

}


