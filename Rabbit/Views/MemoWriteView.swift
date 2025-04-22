//
//  MemoWriteView.swift
//  Rabbit
//
//  Created by 조수원 on 4/20/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct MemoWriteView: View {
    var memo: Memo?
    let userID: String
    
    @Environment(\.dismiss) private var dismiss
    // swiftData 컨텍스트
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack {
// MARK: 메모 작성 시 보이는 타이틀, 내용, 저장 버튼
            HStack {
                Text(memo == nil ? "새 메모" : "메모 수정")
                    .font(.title2.bold())

                Spacer()

                Button(action: {
                    print("제목: \(title), 내용: \(content)")
                    save()
                }) {
                    Text("저장")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            TextField("제목을 입력하세요", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextEditor(text: $content)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
        }
        // 기존 메모 데이터가 있는 경우 뷰에 보여줌
        .onAppear {
            if let memo = memo {
                title = memo.title
                content = memo.content
            }
        }
    }
// MARK: 메모 클릭 시 수정이면 업데이트, 없으면 작성 버튼으로 새로 생성
    private func save() {
        if let memo = memo {
                memo.title = title
                memo.content = content
            print("메모 수정 완료")
        } else {
            let newMemo = Memo(userID: userID , title: title, content: content)
            modelContext.insert(newMemo)
            print("메모 저장 완료")
            print("현재 저장된 유저 ID: \(userID)")
        }
        do {
            try modelContext.save()
        } catch {
            print("메모 저장 안됨: \(error.localizedDescription)")
        }
    dismiss()
    }
}

//#Preview {
//    MemoWriteView(memo: nil)
//}
