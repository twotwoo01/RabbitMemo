//
//  HomeView.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct HomeView: View {
    // swiftData 컨텍스트
    @Environment(\.modelContext) private var modelContext
    
    // 파이어베이스에 로그인된 사용자의 id를 가져옴
    private var userID: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    // swiftData에 저장된 데이터를 사용자 id에 맞게 데이터를 보여줌
    @Query private var memos: [Memo]
    
    // 사용자 id 와 일치하는 데이터만 화면에 보여줌
    var userMemos: [Memo] {
        memos.filter{ $0.userID == userID }
    }

    @State private var memoWrite = false
    @State private var menuSidebar = false
    @State private var menuSearch = false
    @State private var choiceMemo: Memo? = nil
  
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.rabbitBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 바: 왼쪽 메뉴, 중앙 타이틀, 오른쪽 검색
                HStack {
                    // 왼쪽 메뉴 버튼
                    Button {
                        menuSidebar = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 22, height: 16)
                    }

                    Spacer()

                    // 가운데 제목
                    Text("메모")
                        .font(.headline.bold())
                        .foregroundColor(.black)

                    Spacer()

                    // 오른쪽 검색 버튼
                    Button {
                        menuSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)

                // 메모 리스트
                List {
                    ForEach(userMemos, id: \.self) { memo in
                        Button {
                            choiceMemo = memo
                            memoWrite = true
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(memo.title)
                                    .font(.headline)
                                Text(memo.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .onDelete(perform: deleteMemo)
                }
                .listStyle(.plain)
            }

            // 작성 버튼 (오른쪽 하단)
            Button {
                choiceMemo = nil
                memoWrite = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 26))
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding(.bottom, 30)
            .padding(.trailing, 24)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $memoWrite) {
            MemoWriteView(memo: choiceMemo, userID: userID)
        }
        .sheet(isPresented: $menuSidebar) {
            MenuSidebarView(userID: userID)
        }
        .sheet(isPresented: $menuSearch) {
            SearchView()
        }
    }
    private func deleteMemo(at offsets: IndexSet) {
        for index in offsets {
            let memo = userMemos[index]
            modelContext.delete(memo)
        }
        do {
            try modelContext.save()
            print("메모 삭제")
        } catch {
            print("메모 삭제: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HomeView()
}
