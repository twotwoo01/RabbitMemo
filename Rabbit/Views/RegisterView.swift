//
//  RegisterView.swift
//  Rabbit
//
//  Created by 조수원 on 4/21/25.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var registerVM = RegisterViewModel()

    @State private var email = ""
    @State private var password = ""
    @State private var securePassword = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.rabbitBackground).ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("회원가입")
                        .font(.title.bold())
                        .padding(.bottom, 30)

                    VStack(spacing: 20) {
                        TextField("이메일을 입력해주세요", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        HStack {
                            if securePassword {
                                TextField("비밀번호", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("비밀번호", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Button {
                                securePassword.toggle()
                            } label: {
                                Image(systemName: securePassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // 회원가입 실패 에러 메시지
                    if !registerVM.errorMessage.isEmpty {
                        Text(registerVM.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    // 회원가입 비동기 처리
                    Button {
                        Task {
                            await registerVM.register(email: email, password: password)
                        }
                    } label: {
                        Text("가입하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 40)
                            .background(Color.gray)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
            // 회원가입 시 로그인 뷰로 이동
            .onChange(of: registerVM.registerLogin) { Bool, newValue in
                if newValue {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
