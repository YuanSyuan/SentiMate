//
//  MyCustomNavigationController.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/27.
//

import UIKit

class MyCustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // 2
        delegate = self
    }
    
}

extension MyCustomNavigationController: UINavigationControllerDelegate {
 
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        // 3
        return CSCardTransition.navigationController(
            navigationController,
            animationControllerFor: operation,
            from: fromVC,
            to: toVC
        )
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        // 4
        return CSCardTransition.navigationController(
            navigationController,
            interactionControllerFor: animationController
        )
    }
    
}
