//
//  DraggableFloatingView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/2.
//
import UIKit
import SceneKit

class DraggableFloatingView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust the frame based on the subviews, specifically the SCNView if it's your only subview
        if let scnView = subviews.first as? SCNView {
            // Here you can adjust the frame if necessary or apply padding
            frame.size = CGSize(width: scnView.frame.width + 20, height: scnView.frame.height + 20)
            layer.cornerRadius = 15
        }
    }
}
