//
//  PostEntryVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/20.
//

import UIKit
import FirebaseAuth

class PostEntryVC: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var typingLbl: UILabel!
    @IBOutlet weak var backgrounfImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedText = createAttributedText()
            typingAnimation(for: attributedText, in: typingLbl, typingSpeed: 0.2)
        startBtn.addTouchAnimation()
        
        self.navigationItem.backButtonTitle = "返回"
        
        backgrounfImg.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgrounfImg.topAnchor.constraint(equalTo: view.topAnchor),
            backgrounfImg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgrounfImg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgrounfImg.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createAttributedText() -> NSAttributedString {
        let fullText = "嗨！今天過得如何呢\n來填寫今天的情緒日記吧"
        let specialText = "來填寫今天的情緒日記吧"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        paragraphStyle.alignment = .center
      
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        let specialTextRange = (fullText as NSString).range(of: specialText)
        attributedString.addAttribute(.foregroundColor, value: midOrange, range: specialTextRange)
        
        return attributedString
    }

    func typingAnimation(for attributedText: NSAttributedString, in label: UILabel, typingSpeed: TimeInterval) {
        label.attributedText = NSAttributedString(string: "")

        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { [weak label] timer in
            guard let label = label else {
                timer.invalidate()
                return
            }
            if characterIndex < attributedText.length {
                let attributedSubstring = attributedText.attributedSubstring(from: NSRange(location: 0, length: characterIndex + 1))
                label.attributedText = attributedSubstring
                characterIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    @IBAction func startBtnTapped(_ sender: UIButton) {
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let presentVC = storyboard.instantiateViewController(withIdentifier: "login") as? SettingVC {
                self.navigationController?.present(presentVC, animated: true)
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let pushVC = storyboard.instantiateViewController(withIdentifier: "post") as? PostVC {
                self.navigationController?.pushViewController(pushVC, animated: true)
            }
        }
    }
}
