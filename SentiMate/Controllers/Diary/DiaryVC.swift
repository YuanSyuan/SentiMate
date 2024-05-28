//
//  DiaryVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryVC: UIViewController {
    var diary: Diary?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emotionBackground: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var emotionImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var emotionLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        containerView.clipsToBounds = true
        textContainerView.layer.cornerRadius = 20
    }
    
    func configureUI() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .left
        
        let attributes = NSAttributedString(string: diary?.content ?? "",
                                            attributes: [NSAttributedString.Key.paragraphStyle:
                                                            paragraphStyle])
        
        if let emotion = diary?.emotion, let emotionEnum =  Emotions(rawValue: emotion) {
            let emojiText = Emotions.getMandarinEmotion(emotion: emotionEnum)
            emotionImg.image = UIImage(named: emotion)
            emotionLbl.text = emojiText
            emotionBackground.image = UIImage(named: "background\(emotion)")
        }
        
        dateLbl.text = diary?.customTime
        categoryLbl.text = buttonTitles[diary?.category ?? 0]
        contentLbl.attributedText = attributes
    }
}

