//
//  DiaryVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryVC: UIViewController {
    var diary: Diary?
    
    @IBOutlet weak var emotionImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var emotionLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
//    @IBOutlet weak var contentBorderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    func configureUI() {
        let emoji: String
        switch diary?.emotion {
            case "Fear":
            emoji = "fear"
            case "Sad":
            emoji = "sad"
            case "Neutral":
            emoji = "neutral"
            case "Happy":
            emoji = "happy"
            case "Surprise":
            emoji = "surprise"
            case "Angry":
            emoji = "angry"
            default:
            emoji = disgustSinger.randomElement() ?? ""
            }
        
        let emojiText: String
        switch diary?.emotion {
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
        
        emotionImg.image = UIImage(named: emoji)
        dateLbl.text = diary?.customTime
        categoryLbl.text = buttonTitles[diary?.category ?? 0]
        emotionLbl.text = emojiText
        contentLbl.text = diary?.content
//        contentBorderView.layer.borderColor = defaultTextColor.cgColor
//        contentBorderView.layer.borderWidth = 1
    }
}
