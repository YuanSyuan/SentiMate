//
//  OnboardingView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appManager: AppManager
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var pageIndex = 0
    @State private var username: String = ""
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    Spacer()
                    PageView(page: page)
                    if page == pages.last {
                        TextField("怎麼稱呼您呢？", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 300, height: 30, alignment: .center)
                            .padding()
                        Button("開始使用") {
                            appManager.didCompleteOnboarding = true
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.synchronize()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(midOrange))
                        .disabled(username.isEmpty)
                    } else {
                    }
                    Spacer()
                }
                .tag(page.tag)
                .padding(.bottom, keyboard.currentHeight)  // Adjust padding based on keyboard height
                .animation(.easeOut, value: 0.16)// Smooth transition
                        .onTapGesture {
                            self.hideKeyboard()  // Dismiss the keyboard when tapping outside the TextField
                        }
            }
        }
        .animation(.easeInOut, value: pageIndex)// 2
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .black
            dotAppearance.pageIndicatorTintColor = .gray
        }
        .background(Color(defaultBackgroundColor))
        .edgesIgnoringSafeArea(.all)
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

