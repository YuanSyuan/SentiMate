//
//  ContentView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        Group {
            if appManager.didCompleteOnboarding {
                MainAppViewControllerRepresentable()
            } else {
                OnboardingView()
            }
        }
    }
}
