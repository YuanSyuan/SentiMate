//
//  PostEntryVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/20.
//

import UIKit

class PostEntryVC: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var typingLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedText = createAttributedText()
            typingAnimation(for: attributedText, in: typingLbl, typingSpeed: 0.2)
        startBtn.addTouchAnimation()
    }
    
    func createAttributedText() -> NSAttributedString {
        let fullText = "嗨！今天過得如何呢\n來填寫今天的情緒日記吧"
        let specialText = "來填寫今天的情緒日記吧"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
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

}
