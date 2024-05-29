//
// UserProfileView.swift
// Favourites
//
// Created by Peter Friese on 08.07.2022
// Copyright © 2022 Google LLC.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI
import SceneKit
//import FirebaseAnalyticsSwift

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? "設定暱稱"
    
    let textColor = defaultTextColor
    let backgroundColor = defaultBackgroundColor
    
    private func deleteAccount() {
        Task {
                if await viewModel.deleteAccount() {
                    alertMessage = "刪除成功"
                    showAlert = true
                    dismiss()
                } else {
                    alertMessage = "刪除失敗"
                    showAlert = true
                }
            }
    }
    
    private func signOut() {
        Task {
                let signedOut = await viewModel.signOutTapped()
                if signedOut {
                    alertMessage = "登出成功"
                    showAlert = true
                } else {
                    alertMessage = "登出失敗"
                    showAlert = true
                }
            }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        Spacer()
                        Text("設定")
                            .font(.custom("jf-openhuninn-2.0", size: 32))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(backgroundColor))
                        HStack {
                            Spacer()
                            SceneKitView()
                                .frame(width: 200 , height: 200)
                                .clipShape(Circle())
                                .clipped()
                                .padding(4)
                            Spacer()
                        }
                    }
                }
                
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section(header: Text("暱稱").font(.custom("jf-openhuninn-2.0", size: 12))) {
                                NavigationLink(destination: UsernameEditView(username: $username)) {
                                    Text(username)
                                        .foregroundColor(Color(backgroundColor))
                                }
                            }
                Section(header: Text("目前登入的信箱")
                    .font(.custom("jf-openhuninn-2.0", size: 12))) {
                        Text(viewModel.displayName)
                            .foregroundColor(Color(backgroundColor))
                    }
                NavigationLink {
                    Form {
                        Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
                            HStack {
                                Spacer()
                                Text("刪除帳號")
                                    .foregroundColor(Color(backgroundColor))
                                Spacer()
                            }
                        }
                    }
                } label: {
                    Text("帳號管理")
                        .foregroundColor(Color(backgroundColor))
                }
            }
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("通知"), message: Text(alertMessage), dismissButton: .default(Text("確認")))
                    }
            .navigationTitle("")
            .foregroundColor(Color(backgroundColor))
            .confirmationDialog("刪除帳號將會永久性的清除所有資料。您確定要刪除您的帳戶嗎？",
                                isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
                Button("確定刪除", role: .destructive, action: deleteAccount)
                Button("取消", role: .cancel, action: { })
            }
        }
        .customFont(fontName: "jf-openhuninn-2.0", size: 18)
    }
}

struct CustomFontModifier: ViewModifier {
    var fontName: String
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: size))
    }
}

extension View {
    func customFont(fontName: String, size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(fontName: fontName, size: size))
    }
}

struct SceneKitView: UIViewRepresentable {
    @ObservedObject var firebaseManager = FirebaseManager.shared
    
    func makeUIView(context: Context) -> SCNView {
            let sceneView = SCNView()
            updateScene(sceneView: sceneView)
            return sceneView
        }

        func updateUIView(_ uiView: SCNView, context: Context) {
            updateScene(sceneView: uiView)
        }

        private func updateScene(sceneView: SCNView) {
           let emotion = firebaseManager.diaries.first?.emotion ?? "Neutral"
            if let emotionEnum = Emotions(rawValue: emotion) {
                let sceneEmoji = Emotions.getSceneEmoji(emotion: emotionEnum)
                sceneView.scene = SCNScene(named: sceneEmoji)
                sceneView.autoenablesDefaultLighting = true
                sceneView.allowsCameraControl = true
            }
        }
}