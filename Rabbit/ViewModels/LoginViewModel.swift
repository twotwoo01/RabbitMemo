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
    @Published var isLoggedIn = false

// MARK: 파이어베이스 로그인 연동
    func login(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            print("ID: \(email),PW: \(password), 로그인 성공")
            isLoggedIn = true
        } catch {
            print("로그인 실패: \(error.localizedDescription)")
            await register(email: email, password: password)
        }
    }
    
// MARK: 로그인 실패시 자동회원가입
    private func register(email: String, password: String) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("ID: \(email),PW: \(password), 회원가입 성공")
            isLoggedIn = true
        } catch {
            print("회원가입 실패: \(error.localizedDescription)")
        }
    }
}
