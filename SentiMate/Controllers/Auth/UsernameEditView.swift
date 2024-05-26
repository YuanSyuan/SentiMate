//
//  UsernameEditView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/10.
//

import SwiftUI

struct UsernameEditView: View {
    @Binding var username: String
        @Environment(\.dismiss) var dismiss

//       @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""

       var body: some View {
           Form {
               TextField("輸入新暱稱", text: $username)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding()
               HStack{
                   Spacer()
                   Button("儲存") {
                       saveUsername()
                   }
                   .padding()
                   .frame(width: 100, height: 40)
                   .background(Color(defaultBackgroundColor))
                   .foregroundColor(Color(defaultTextColor))
                   .clipShape(RoundedRectangle(cornerRadius: 10))
                   Spacer()
               }
           }
           .navigationTitle("更新暱稱")
       }

       private func saveUsername() {
           UserDefaults.standard.set(username, forKey: "username")
           NotificationCenter.default.post(name: NSNotification.Name("UserNameUpdated"), object: nil, userInfo: ["userName": username])
           dismiss()
       }
}
