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
    @IBOutlet weak var contentBorderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    func configureUI() {
        dateLbl.text = diary?.customTime
        categoryLbl.text = buttonTitles[diary?.category ?? 0]
        emotionLbl.text = diary?.emotion
        contentLbl.text = diary?.content
        contentBorderView.layer.borderColor = UIColor.gray.cgColor
        contentBorderView.layer.borderWidth = 2
    }
}
