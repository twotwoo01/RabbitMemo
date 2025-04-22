//
//  RegisterViewModel.swift
//  Rabbit
//
//  Created by 조수원 on 4/21/25.
//

import Foundation
import FirebaseAuth

@MainActor
class registerViewModel: ObservableObject {
    @Published var registerLogin = false
    @Published var errorMessage = ""
    
    func register(email: String, password: String) async {
        if email.isEmpty {
            errorMessage = "이메일을 입력해주세요"
            return
        }
        if !email.contains("@") {
            errorMessage = "이메일 형식으로 입력해주세요"
            return
        }
        if password.isEmpty {
            errorMessage = "비밀번호를 입력해주세요"
            return
        }
        
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("회원가입 성공. ID: \(email), PW: \(password)")
            registerLogin = true
        } catch {
            errorMessage = "회원가입 실패: \(error.localizedDescription)"
        }
    }
}
