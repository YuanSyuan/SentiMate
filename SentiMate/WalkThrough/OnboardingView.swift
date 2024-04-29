//
//  OnboardingView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appManager: AppManager
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
//                    Spacer()
                    if page == pages.last {
                        TextField("怎麼稱呼您呢？", text: $username)
                                                  .textFieldStyle(RoundedBorderTextFieldStyle())
                                                  .frame(width: 300, height: 30, alignment: .center)
                                                  .padding()
                        Button("開始使用") {
                                    appManager.didCompleteOnboarding = true
                                }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(midOrange))
                    } else {
//                        Button("next", action: incrementPage)
//                            .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)// 2
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .black
            dotAppearance.pageIndicatorTintColor = .gray
        }
        .background(Color(defaultBackgroundColor)) // Apply your chosen background color here
        .edgesIgnoringSafeArea(.all)
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
//    func goToZero() {
//        pageIndex = 0
//    }
}

