//
//  LoginView.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginClick = false // 로그인 버튼 클릭 여부
    @State private var emailError: String = "" // 이메일 형식이 아닌 형식으로 로그인 시도했을 때
    @State private var securePassword = false // 비밀번호 보기 눈 모양 버튼
    @State private var errorMessage: String = "" // 로그인 시 가입 안 되어있으면 에러 문구 뜸
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.rabbitBackground).ignoresSafeArea()
// MARK: 로고, 로그인 버튼, id pw 텍스트 필드
                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .scaleEffect(loginClick ? 1 : 1)
                        .offset(y: loginClick ? -60 : 0)
                        .animation(.easeInOut, value: loginClick)
                    // 로그인 버튼을 클릭했을 때
                    if loginClick {
                        VStack {
                            TextField("아이디를 입력해주세요.", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        // 비밀번호 확인 버튼
                            HStack {
                                if securePassword {
                                    TextField("비밀번호를 입력해주세요.", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                } else {
                                    SecureField("비밀번호를 입력해주세요.", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                Button {
                                    securePassword.toggle()
                                } label: {
                                    Image(systemName: securePassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                            //
                            if !loginVM.errorMessage.isEmpty {
                                Text(loginVM.errorMessage)
                                    .foregroundStyle(.red)
                                    .font(.caption)
                            }
                            // 이메일이 아닌 다른 형식으로 입력했을 때
                            Button {
                                if email.contains("@") {
                                    Task {
                                        await loginVM.login(email: email, password: password)
                                    }
                                } else {
                                    loginVM.errorMessage = "이메일 형식으로 입력해주세요."
                                }
                            } label: {
                                Text("로그인")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                            }
                            NavigationLink("회원가입", destination: RegisterView())
                                .font(.caption)
                        }
                    } else {
                        Button {
                            withAnimation {
                                loginClick = true
                            }
                        } label: {
                            Text("로그인")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 40)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $loginVM.login) {
                HomeView()
            }
        }
    }
}

#Preview {
    LoginView()
}
