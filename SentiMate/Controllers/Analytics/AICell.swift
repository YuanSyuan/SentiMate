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
    
    // MARK: - initial UI setup
    private func setupViews() {
        contentView.backgroundColor = defaultBackgroundColor
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = defaultTextColor
        titleLabel.textAlignment = .left
        titleLabel.font = customFontTitle
        titleLabel.text = "AI諮商室"
        
        AIResponseLbl.numberOfLines = 0
        AIResponseLbl.textColor = defaultBackgroundColor
        AIResponseLbl.font = customFontInt
        AIResponseLbl.layer.borderColor = defaultBackgroundColor.cgColor
        containerView.backgroundColor = defaultTextColor
        containerView.layer.cornerRadius = 20
        
        callAIBtn.setTitle("查看AI分析", for: .normal)
        callAIBtn.setTitleColor(defaultBackgroundColor, for: .normal)
        callAIBtn.backgroundColor = midOrange
        callAIBtn.layer.cornerRadius = 12
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        containerView.addSubview(AIResponseLbl)
        containerView.addSubview(callAIBtn)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        AIResponseLbl.translatesAutoresizingMaskIntoConstraints = false
        callAIBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            AIResponseLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            AIResponseLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            AIResponseLbl.heightAnchor.constraint(equalToConstant: 340)
        ])
        
        NSLayoutConstraint.activate([
            callAIBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 70),
            callAIBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -70),
            callAIBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            callAIBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        callAIBtn.addTarget(self, action: #selector(callAIBtnTapped), for: .touchUpInside)
    }
    
    @objc func callAIBtnTapped(_ sender: UIButton) {
        delegate?.aiButtonTapped(cell: self)
    }
    
    // MARK: - Configurations
    func configureEmojis(with emojiNames: [String]) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: AIResponseLbl.topAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50)
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
    }
    
    func updateAIResponse(with response: String?) {
        if let response = response {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4
                    paragraphStyle.alignment = .left
                    
                    let attributes = NSAttributedString(string: response, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                    AIResponseLbl.textAlignment = .left
                    AIResponseLbl.attributedText = attributes
                } else {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4
                    paragraphStyle.alignment = .center
                    
                    let newAttributes = NSAttributedString(string: "最近七筆日記裡面，情緒有些變動呢\n點擊下方按鈕查看AI分析吧！",
                                                           attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                    AIResponseLbl.textAlignment = .center
                    AIResponseLbl.attributedText = newAttributes
                }
    }
    
}
