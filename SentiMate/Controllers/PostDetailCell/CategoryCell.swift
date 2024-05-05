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
    private var categoryButtons: [UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if categoryButtons.isEmpty {
                setupButtons()
            }
        
        let attributedString = NSMutableAttributedString(string: "我想是因為 *")
        attributedString.addAttribute(.foregroundColor, value: defaultTextColor, range: NSMakeRange(0, 5))
        attributedString.addAttribute(.foregroundColor, value: midOrange, range: NSMakeRange(6, 1))
        categoryLbl.attributedText = attributedString
        
        selectedButton?.addTouchAnimation()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupButtons() {
        let numberOfRows = 3
        let numberOfColumns = 4
        let buttonHeight: CGFloat = 30
        let buttonSpacing: CGFloat = 10

        var lastRowButtons: [UIButton] = []

        for rowIndex in 0..<numberOfRows {
            var previousButton: UIButton?

            for columnIndex in 0..<numberOfColumns {
                let buttonIndex = rowIndex * numberOfColumns + columnIndex
                if buttonIndex >= buttonTitles.count { break }  // Stop if there are no more titles
                let buttonTitle = buttonTitles[buttonIndex]
                
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.backgroundColor = midOrange
                button.setTitleColor(defaultTextColor, for: .normal)
                button.alpha = 0.5
                button.layer.cornerRadius = 5
                button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
                
                button.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(button)
                categoryButtons.append(button)

                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: buttonHeight),
                    button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / CGFloat(numberOfColumns), constant: -(CGFloat(numberOfColumns + 1) * buttonSpacing) / CGFloat(numberOfColumns)),
                    button.topAnchor.constraint(equalTo: rowIndex == 0 ? categoryLbl.bottomAnchor : lastRowButtons[0].bottomAnchor, constant: buttonSpacing)
                ])

                if let previousButton = previousButton {
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: buttonSpacing).isActive = true
                } else {
                    button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: buttonSpacing).isActive = true
                }

                previousButton = button
            }

            if let firstButtonInRow = previousButton {
                lastRowButtons = [firstButtonInRow]
            }
        }
    }

    
    @objc func categoryButtonTapped(sender: UIButton) {
            // Reset all buttons to unselected state
            categoryButtons.forEach {
                $0.alpha = 0.5
                $0.setTitleColor(defaultTextColor, for: .normal)
            }
            
            sender.alpha = 1.0
            sender.setTitleColor(defaultBackgroundColor, for: .normal)
            
            selectedButton = sender
            
            guard let index = categoryButtons.firstIndex(of: sender) else { return }
            onCategorySelected?(index)
        }
    
    func setCategoryIndex(_ index: Int?) {
        guard let index = index, index < categoryButtons.count else {
            print("Invalid index or buttons not setup")
            return
        }
        let button = categoryButtons[index]
        categoryButtonTapped(sender: button)
    }
    
}
