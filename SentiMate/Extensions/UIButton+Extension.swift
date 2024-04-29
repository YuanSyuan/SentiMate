//
//  UIButton+Extension.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/29.
//

import UIKit

extension UIButton {
    func addTouchAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func animateUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}

