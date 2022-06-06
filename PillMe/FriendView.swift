//
//  FriendView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/04.
//

import SwiftUI


struct FriendView : View{
    
    let data = Array(1...4).map {"친구\($0)"}

    let colums = [
        GridItem(.adaptive(minimum: 100))
    ]

    @State var friendManager = FriendManager.friendManager
    
    @State var userID : String
    @State private var searchText = ""
    @State var FriendList : [FriendListModel] = []

    
    @State private var shouldShowAlert : Bool = false
    @State private var popupText : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View{
        ZStack{
            //배경색
            Color(red: 102/255, green: 103/255, blue: 171/255)
                .edgesIgnoringSafeArea(.all)
            VStack{
                /*1.검색창*/
                SearchBarView(searchType: "friend", text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                /*2.친구 추가 버튼*/
                Button(action:{
                    var addFriendManager = AddFriendManager.addFriendManager
                    addFriendManager.run1 = true
                    addFriendManager.run2 = true
                    addFriendManager.run3 = true
                    
                    if searchText == ""
                    {
                        //공백을 입력한 경우
                        shouldShowAlert = true
                        popupText = "추가할 친구 아이디를 입력해주세요"
                        print("11111\n")
                    }
                    
                    else if searchText == userID
                    {
                        //입력이 본인의 아이디와 동일할 경우
                        shouldShowAlert = true
                        popupText = "본인의 아이디는 등록 할 수 없습니다"
                        print("22222\n")
                    }
                    
                    else if (addFriendManager.MemberCheck(searchID: searchText).first?.userID ?? "") != searchText
                    {
                        //검색한 친구가 없을경우
                        shouldShowAlert = true
                        popupText = "입력하신 아이디에 해당하는 친구가 없습니다."
                        print("33333\n")
                    }
                    
                    else if (addFriendManager.FriendCheck(userID: userID, searchID: searchText).first?.FriendID ?? "") == searchText
                    {
                        //이미 친구가 등록되어 있는 경우
                        shouldShowAlert = true
                        popupText = "이미 등록된 친구입니다."
                        print("44444\n")

                    }
                    
                    else
                    {
                        //친구를 등록하는 과정
                        addFriendManager.addFriend(userID: userID, searchID: searchText)
                        //친구리스트 갱신
                        self.friendManager.run1 = true
                        self.FriendList = self.friendManager.getFriendList(userID: self.userID)
                        print("555555\n")
                    }
                }) {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(red: 155/255, green: 89/255, blue: 182/255))
                        .frame(width: .infinity, height: 65)
                        .overlay(
                            Text("+")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .font(.system(size: 70))
                        )
                        .padding()
                }
                /*3.친구 리스트*/
                ScrollView{
                    LazyVGrid(columns: colums, spacing: 20){
                        ForEach(self.FriendList) { value in
                            VStack{
                                NavigationLink(destination: FriendInfoView(userID: userID, friendID: value.FriendID ?? "")){
                                    RoundedRectangle(cornerRadius: 35)
                                        .fill(Color(red:188/255, green: 191/255, blue:240/255))
                                        .frame(height: 100)
                                        .overlay(Image(
                                            systemName: "person.crop.square")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color.gray)
                                        )
                                }
                                Text(value.FriendID ?? "")
                                    .foregroundColor(.secondary)
                            }
                        }

                    }.padding(.horizontal)
                }
            }
            .onAppear(perform: {
                self.friendManager.run1 = true
                self.FriendList = self.friendManager.getFriendList(userID: self.userID)
            })
        }.animation(.none)
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                dismissButton: .default(Text("확인")))
        })
    }
}

//struct FreindView_Previews : PreviewProvider{
//    static var previews: some View{
//        FriendView()
//    }
//}

//private extension FriendView{
//    var FriendInfoAction: some View{//친구정보뷰 액션
//        NavigationLink(destination: FriendInfoView()){
//            RoundedRectangle(cornerRadius: 35)
//                .fill(Color(red:188/255, green: 191/255, blue:240/255))
//                .frame(height: 100)
//                .overlay(Image(
//                    systemName: "person.crop.square")
//                    .font(.system(size: 50))
//                    .foregroundColor(Color.gray)
//                )
//        }
//    }
//}

//화면 터치시 키보드 숨김
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
