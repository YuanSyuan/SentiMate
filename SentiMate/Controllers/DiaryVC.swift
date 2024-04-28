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
        
        navigationController?.navigationBar.isHidden = true
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

//        private func backgroundImg(forEmotion emotion: String?) -> String {
//            switch emotion {
//            case "Fear":
//                return "nature14"
//            case "Sad":
//                return "nature6"
//            case "Neutral":
//                return "nature16"
//            case "Happy":
//                return "nature5"
//            case "Surprise":
//                return "nature12"
//            case "Angry":
//                return "nature17"
//            default:
//                return "nature2"
//            }
//        }

        func configureUI() {
            if let emotion = diary?.emotion {
                let emojiText = emojiText(forEmotion: emotion)
//                let backgroundImg = backgroundImg(forEmotion: emotion)
                
                emotionImg.image = UIImage(named: emotion)
                emotionLbl.text = emojiText
                emotionBackground.image = UIImage(named: "background\(emotion)")
            }
            
            dateLbl.text = diary?.customTime
            categoryLbl.text = buttonTitles[diary?.category ?? 0]
            contentLbl.text = diary?.content
            // contentBorderView.layer.borderColor = defaultTextColor.cgColor
            // contentBorderView.layer.borderWidth = 1
        }
    }

extension DiaryVC: CSCardPresentedView {
    
    private func activateSmallConstraint() {
        bigConstraints.forEach { (constraint) in
            constraint.isActive = false
        }
        smallConstraints.forEach { (constraint) in
            constraint.isActive = true
        }
    }
    
    private func activateBigConstraint() {
        smallConstraints.forEach { (constraint) in
            constraint.isActive = false
        }
        bigConstraints.forEach { (constraint) in
            constraint.isActive = true
        }
    }
    
    func cardPresentedViewDidUpdatePresentingTransition(progress: CGFloat) {
        containerView.layer.cornerRadius = 12-progress*12
//        lyricsCellView.titleLabel.font = lyricsCellView.titleLabel.font.withSize(24+progress*24)
    }
    
    func cardPresentedViewDidStartPresenting() {
        // Layout changes are automatically animated when written here
        activateBigConstraint()
    }
    
    func cardPresentedViewWillEndPresenting() {
        containerView.layer.cornerRadius = 0
//        lyricsCellView.titleLabel.font = lyricsCellView.titleLabel.font.withSize(48)
    }
    func cardPresentedViewDidStartDismissing() {
        activateSmallConstraint()
    }
    
    // Dismissing the view
    func cardPresentedViewWillCancelDismissing() {
        cardPresentedViewWillEndPresenting()
    }
    func cardPresentedViewDidUpdateDismissingTransition(progress: CGFloat) {
        containerView.layer.cornerRadius = min(progress*4, 1)*12
//        lyricsCellView.titleLabel.font = lyricsCellView.titleLabel.font.withSize(48-progress*24)
    }
    func cardPresentedViewWillEndDismissing() {
        containerView.layer.cornerRadius = 12
//        lyricsCellView.titleLabel.font = lyricsCellView.titleLabel.font.withSize(24)
    }
}
