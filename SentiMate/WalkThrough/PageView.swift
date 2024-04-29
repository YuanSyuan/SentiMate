//
//  PageView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import SwiftUI

struct PageView: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 10) {
            Text(page.name)
                .font(.custom("PingFangTC-Medium", size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(Color(defaultTextColor))
            Text(page.styledDescription())
                .font(.custom("PingFangTC-Medium", size: 16))
                .frame(width: 300)
                .multilineTextAlignment(.center)
            //                .padding()
                .foregroundColor(Color(defaultTextColor))
            if let imageUrl = page.imageUrl, !imageUrl.isEmpty {
                Image(imageUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .padding()
                //                                .cornerRadius(30)
                //                                .background(Color.gray.opacity(0.10))
                //                                .cornerRadius(10)
            }
            
        }
    }
}
