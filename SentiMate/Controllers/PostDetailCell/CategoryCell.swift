//
//  CategoryCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    
    let buttonTitles = ["工作", "學習", "感情", "社會", "家庭", "人際", "健康", "文化", "娛樂", "休閒", "生活", "個人目標"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupButtons() {
        let numberOfRows = 3
        let numberOfColumns = 4
        let buttonHeight: CGFloat = 30
        let buttonWidth: CGFloat = (self.bounds.width - (CGFloat(numberOfColumns + 1) * 10)) / CGFloat(numberOfColumns) // Assuming 10 points space between buttons

        for rowIndex in 0..<numberOfRows {
            for columnIndex in 0..<numberOfColumns {
                let buttonIndex = rowIndex * numberOfColumns + columnIndex
                let buttonTitle = buttonTitles[buttonIndex]
                
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.backgroundColor = .darkGray
                button.setTitleColor(.white, for: .normal)
                
                // Set frame or constraints
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
            guard let buttonTitle = sender.titleLabel?.text else { return }
            // Do something with the button title
            print("\(buttonTitle) button tapped")
        }
}
