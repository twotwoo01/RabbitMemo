//
//  RegisterViewModel.swift
//  Rabbit
//
//  Created by 조수원 on 4/21/25.
//

import Foundation
import FirebaseAuth

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var registerLogin = false
    @Published var errorMessage = ""
    
    func register(email: String, password: String) async { // 가드문으로 변경
        guard !email.isEmpty else {
            errorMessage = "이메일을 입력해주세요"
            return
        }
        
        guard emailCheck(email) else {
            errorMessage = "이메일 형식이 유효하지 않습니다"
            return
        }

        guard !password.isEmpty else {
            errorMessage = "비밀번호를 입력해주세요"
            return
        }
        
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("회원가입 성공. ID: \(email), PW: \(password)")
            registerLogin = true
        } catch {
            // case 문으로 파이어베이스 로그인 오류 체크
            let errorCode = AuthErrorCode(rawValue: (error as NSError).code)
            switch errorCode {
            case .emailAlreadyInUse:
                errorMessage = "이미 가입된 이메일입니다"
            case .invalidEmail:
                errorMessage = "이메일 형식이 유효하지 않습니다"
            case .weakPassword:
                errorMessage = "6자 이상의 비밀번호로 설정해주세요"
            case .networkError:
                errorMessage = "네트워크 오류가 발생했습니다. 연결 상태 확인 후 다시 시도해주세요"
            default:
                errorMessage = "회원가입 실패: \(error.localizedDescription)"
            }
        }
    }
    // 정규표현식으로 변경
    private func emailCheck(_ str: String)  -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
}

