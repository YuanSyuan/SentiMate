//
//  CategoryCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryLbl: UILabel!
    var onCategorySelected: ((Int) -> Void)?
    private var selectedButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attributedString = NSMutableAttributedString(string: "我想是因為 *")
        // 從第1個字開始，5個字都設置為 defaultTextColor
        attributedString.addAttribute(.foregroundColor, value: defaultTextColor, range: NSMakeRange(0, 5))
        // 從第7個字開始，後面7個字都設置為 midOrange
        attributedString.addAttribute(.foregroundColor, value: midOrange, range: NSMakeRange(6, 1))
        categoryLbl.attributedText = attributedString
        
        selectedButton?.addTouchAnimation()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtons()
    }
    
    
    func setupButtons() {
        let numberOfRows = 3
        let numberOfColumns = 4
        let buttonHeight: CGFloat = 30
        let buttonWidth: CGFloat = (self.contentView.frame.width - (CGFloat(numberOfColumns + 1) * 10)) / CGFloat(numberOfColumns)
        
        for rowIndex in 0..<numberOfRows {
            for columnIndex in 0..<numberOfColumns {
                let buttonIndex = rowIndex * numberOfColumns + columnIndex
                let buttonTitle = buttonTitles[buttonIndex]
                
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.backgroundColor = midOrange
                button.setTitleColor(defaultTextColor, for: .normal)
                button.alpha = 0.5
                button.layer.cornerRadius = 5
                
                button.translatesAutoresizingMaskIntoConstraints = false
                self.contentView.addSubview(button)
                
                // Constraints
                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: buttonHeight),
                    button.widthAnchor.constraint(equalToConstant: buttonWidth),
                    button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CGFloat(columnIndex) * (buttonWidth + 10) + 10),
                    button.topAnchor.constraint(equalTo: self.categoryLbl.bottomAnchor, constant: CGFloat(rowIndex) * (buttonHeight + 10) + 10)
                ])
                
                // Add actions
                button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc func categoryButtonTapped(sender: UIButton) {
        contentView.subviews.compactMap { $0 as? UIButton }.forEach {
            $0.alpha = 0.5
            $0.setTitleColor(defaultTextColor, for: .normal)
        }
        
        selectedButton = sender
        selectedButton?.alpha = 1.0
        selectedButton?.setTitleColor(defaultBackgroundColor, for: .normal)
        
        guard let buttonTitle = sender.titleLabel?.text,
              let index = buttonTitles.firstIndex(of: buttonTitle) else {
            return
        }
        onCategorySelected?(index)
    }
    
}
