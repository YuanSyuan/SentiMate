//
//  TestDeleteVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/5.
//

import UIKit
import SwiftUI

class TestDeleteVC: UIViewController {
    var viewModel = AuthenticationViewModel() // Ensure there's an instance of the ViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the UserProfileView with the ViewModel
        let userProfileView = UserProfileView().environmentObject(viewModel)

        // Create a hosting controller with userProfileView
        let hostingController = UIHostingController(rootView: userProfileView)

        // Add the hosting controller as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set constraints for the hosting controller's view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
