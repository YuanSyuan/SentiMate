//
//  TextFieldCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

class TextFieldCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textField: UITextView!

    @IBOutlet weak var saveBtn: UIButton!
    
    var onSave: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        
        textField.text = "說說今天發生什麼事吧！"
        textField.textColor = UIColor.lightGray
        
        textViewDidBeginEditing(textField)
        textViewDidEndEditing(textField)
        
        saveBtn.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "說說今天發生什麼事吧！"
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func saveBtnTapped(_ sender: Any) {
        onSave?()
    }
    
}

