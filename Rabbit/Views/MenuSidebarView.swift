//
//  MenuSidebarView.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
//

import SwiftUI
import FirebaseAuth

struct MenuSidebarView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var trashClick = false
    
    var userID: String
    // 로그인한 사용자의 이메일 가져오기
    let userEmail = Auth.auth().currentUser?.email ?? ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(userEmail)
                .font(.headline)
            
            Divider() // 제목과 내용 구분선

            Button(action: {
                print("삭제된 메모")
                trashClick = true
            }) {
                Text("삭제된 메모")
                    .padding(.horizontal)
            }
            Spacer()

            Button(action: {
                print("설정")
                dismiss()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "gearshape")
                        .font(.title2)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.rabbitBackground))
        .sheet(isPresented: $trashClick) {
            TrashView()
        }
    }
}

#Preview {
    MenuSidebarView(userID: "")
}
