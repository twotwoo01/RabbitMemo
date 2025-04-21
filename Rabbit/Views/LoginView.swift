//
//  LoginView.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var LoginVM = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginClick = false // 로그인 버튼 클릭 여부 
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
                            
                            SecureField("비밀번호를 입력해주세요.", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            

                            Button(action: {
                                print("ID: \(email), PW: \(password) 로그인")
                                // 비동기로 로그인 실행
                                Task {
                                    await LoginVM.login(email: email, password: password)
                                }
                            }) {
                                Text("로그인")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                            }
                        }
                    } else { // 클릭하지 않았을 때 기본 상태
                        Button(action: {
                            withAnimation {
                                loginClick = true
                            }
                        }) {
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
            // 아이디와 비밀번호를 입력하고서 로그인 버튼을 눌러야 홈뷰로 이동
            .navigationDestination(isPresented: $LoginVM.isLoggedIn) {
                HomeView()
            }
        }
    }
}
#Preview {
    LoginView()
}
