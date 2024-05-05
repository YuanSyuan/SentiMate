//
//  AICell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import UIKit

protocol AICellDelegate: AnyObject {
    func aiButtonTapped(cell: AICell)
}

class AICell: UITableViewCell {
    let titleLabel = UILabel()
    var imageViews = [UIImageView]()
    let AIResponseLbl = UILabel()
    let containerView = UIView()
    let callAIBtn = UIButton()
    
    weak var delegate: AICellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        callAIBtn.addTouchAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = defaultBackgroundColor
        
        titleLabel.numberOfLines = 1
                titleLabel.textColor = defaultTextColor
                titleLabel.textAlignment = .left
                titleLabel.font = customFontTitle
                contentView.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "AI諮商室"
        
        AIResponseLbl.numberOfLines = 0
        AIResponseLbl.textColor = defaultBackgroundColor
        AIResponseLbl.font = customFontInt
        containerView.backgroundColor = defaultTextColor
//        containerView.layer.borderColor = defaultTextColor.cgColor
//        containerView.layer.borderWidth = 2
        callAIBtn.setTitle("查看AI分析", for: .normal)
        callAIBtn.setTitleColor(defaultBackgroundColor, for: .normal)
        callAIBtn.backgroundColor = midOrange
        callAIBtn.layer.cornerRadius = 4
      
        contentView.addSubview(containerView)
        contentView.addSubview(AIResponseLbl)
        contentView.addSubview(callAIBtn)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        AIResponseLbl.translatesAutoresizingMaskIntoConstraints = false
        callAIBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                   titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                   titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
               ])
        
        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 380)
        ])
        
        NSLayoutConstraint.activate([
            AIResponseLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            AIResponseLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            AIResponseLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            AIResponseLbl.heightAnchor.constraint(equalToConstant: 340)
        ])
        
        NSLayoutConstraint.activate([
            callAIBtn.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            callAIBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            callAIBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            callAIBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        callAIBtn.addTarget(self, action: #selector(callAIBtnTapped), for: .touchUpInside)
    }
    
    func configure(with emojiNames: [String]) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
        ])
        
        
        imageViews.forEach { $0.removeFromSuperview() }
                imageViews.removeAll()
        
                    for emojiName in emojiNames {
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFit
                    imageView.clipsToBounds = true
                    imageView.image = UIImage(named: emojiName)
                    imageViews.append(imageView)
                    stackView.addArrangedSubview(imageView)
                }
        
//        for (index, imageView) in imageViews.enumerated() {
//                UIView.animate(withDuration: 0.5, delay: Double(index) * 0.3, options: [], animations: {
//                    imageView.alpha = 1
//                }, completion: nil)
//            }
        }
    
    @objc func callAIBtnTapped(_ sender: UIButton) {
        delegate?.aiButtonTapped(cell: self)
    }

}

