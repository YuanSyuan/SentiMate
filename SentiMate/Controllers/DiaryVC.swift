//
//  DiaryVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryVC: UIViewController {
    var diary: Diary?
    
    lazy var cardTransitionInteractor: CSCardTransitionInteractor? = CSCardTransitionInteractor(viewController: self)
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var bigConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var smallConstraints: [NSLayoutConstraint]!
    
    
    @IBOutlet weak var emotionBackground: UIImageView!
    @IBOutlet weak var emotionImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var emotionLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    //    @IBOutlet weak var contentBorderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        view.backgroundColor = .clear
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.systemFill.cgColor
        //        lyricsCellView.contentView.layer.shadowOpacity = 0
        //        lyricsCellView.iconImageView.layer.cornerRadius = 0
        containerView.clipsToBounds = true
    }
    
    private func emojiText(forEmotion emotion: String?) -> String {
        switch emotion {
        case "Fear":
            return "緊張"
        case "Sad":
            return "難過"
        case "Neutral":
            return "普通"
        case "Happy":
            return "開心"
        case "Surprise":
            return "驚喜"
        case "Angry":
            return "生氣"
        default:
            return "厭惡"
        }
    }
    
    func configureUI() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .left
        
        let attributes = NSAttributedString(string: diary?.content ?? "",
                                            attributes: [NSAttributedString.Key.paragraphStyle:
                                                            paragraphStyle])
        
        if let emotion = diary?.emotion {
            let emojiText = emojiText(forEmotion: emotion)
            //                let backgroundImg = backgroundImg(forEmotion: emotion)
            
            emotionImg.image = UIImage(named: emotion)
            emotionLbl.text = emojiText
            emotionBackground.image = UIImage(named: "background\(emotion)")
        }
        
        dateLbl.text = diary?.customTime
        categoryLbl.text = buttonTitles[diary?.category ?? 0]
        contentLbl.attributedText = attributes
        // contentBorderView.layer.borderColor = defaultTextColor.cgColor
        // contentBorderView.layer.borderWidth = 1
    }
}

