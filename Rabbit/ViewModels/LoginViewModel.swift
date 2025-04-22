//
//  LoginViewModel.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
//

import Foundation
import FirebaseAuth // 파이어베이스 로그인

@MainActor
class LoginViewModel: ObservableObject {
    @Published var login = false
    @Published var loginError: String = ""
    @Published var errorMessage: String = ""
    
    // MARK: 파이어베이스 로그인 연동
    func login(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            print("ID: \(email),PW: \(password), 로그인 성공")
            login = true
            loginError = ""
            errorMessage = ""
        } catch {
            print("로그인 실패: \(error.localizedDescription)")
            loginError = "로그인 실패: \(error.localizedDescription)"
            errorMessage = "가입되지 않은 계정입니다." 
            login = false
        }
    }
}
