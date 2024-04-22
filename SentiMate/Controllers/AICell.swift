//
//  AICell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import UIKit

protocol AICellDelegate: AnyObject {
    func aiButtonTapped()
}

class AICell: UITableViewCell {
    var imageViews = [UIImageView]()
    let AIResponseLbl = UILabel()
    let containerView = UIView()
    let callAIBtn = UIButton()
    
    weak var delegate: AICellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = defaultBackgroundColor
        
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.alignment = .center
//        stackView.spacing = 5
//        
        AIResponseLbl.numberOfLines = 0
        AIResponseLbl.textColor = defaultTextColor
        AIResponseLbl.textAlignment = .center
        AIResponseLbl.font = UIFont.systemFont(ofSize: 16)
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = defaultTextColor.cgColor
        containerView.layer.borderWidth = 2
        callAIBtn.setTitle("點擊", for: .normal)
        callAIBtn.setTitleColor(.black, for: .normal)
        callAIBtn.backgroundColor = defaultTextColor
      
//        for _ in 0..<7 {
//            let imageView = UIImageView()
//            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds = true
//            imageView.image = UIImage(systemName: "smiley.fill")
//            imageViews.append(imageView)
//            stackView.addArrangedSubview(imageView)
//        }
        
//        contentView.addSubview(stackView)
        contentView.addSubview(containerView)
        contentView.addSubview(AIResponseLbl)
        contentView.addSubview(callAIBtn)
        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        AIResponseLbl.translatesAutoresizingMaskIntoConstraints = false
        callAIBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for stack view
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
//        ])
        
        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            AIResponseLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            AIResponseLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            AIResponseLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            AIResponseLbl.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            callAIBtn.topAnchor.constraint(equalTo: AIResponseLbl.bottomAnchor, constant: 20),
            callAIBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            callAIBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            callAIBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
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
        }
    
    @objc func callAIBtnTapped(_ sender: UIButton) {
        delegate?.aiButtonTapped()
    }

}

