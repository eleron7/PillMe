//
//  Profile.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/01.
//

import SwiftUI

struct nearTimePill{
    var PillName : String
    var NearPillTime : String
    var NearPillTimeVal : Int
}

struct ProfileView : View{
    
    @State private var shouldShowAlert : Bool = false
    @State private var popupText : String = ""

    @Environment(\.presentationMode) var presentationMode
    
    @State var userID : String//사용자 ID
    @State var userName : String//사용자 이름
    @State var nextEatName : String = ""//다음약 이름
    @State var nextEatTime : String = ""//다음약 시간
    var userImg : String = ""//프로필 이미지
    @State var timeResult : [pillTimeModel] = []// 시간 결과값

    var body : some View{
        HStack{
            /*1.사용자 정보*/
            VStack(alignment: .center){
                Text(userName+"님")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size:35))
                Text(nextEatName + "\n" + nextEatTime)
                    .foregroundColor(.red)
                    .font(.system(size:20))
            }
            Spacer()
            /*2.사용자 프로필 (메뉴)*/
            Menu(content: {
                /*로그아웃 기능*/
                Button(action: {
                    print("로그아웃 버튼 클릭")
                    print("")
                    presentationMode.wrappedValue.dismiss()
                    shouldShowAlert = true
                    popupText = "로그아웃 되었습니다."
                }, label: {
                    Label("로그아웃", systemImage: "rectangle.portrait.and.arrow.right.fill")
                })
            }, label: {
                Circle()
                    .fill(Color(red: 224/255, green: 224/255, blue: 224/255))
                    .frame(width: 100, height: 100, alignment: .center)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size:50))
                            .foregroundColor(Color(red: 95/255, green: 141/255, blue: 172/255)))
            })
        }
        .onAppear(perform: {
            var getCurrentTime = getCurrentTimeManager.currentTimeManager
            getCurrentTime.run = true
            self.timeResult = getCurrentTime.getCurrentTime(pillMaster: self.userID)
            
            self.nextEatName = self.timeResult.first?.PillName ?? ""
            self.nextEatTime = self.timeResult.first?.EatTime ?? ""
        })
        .padding(.all)
        .frame(height: 150, alignment: .center)
        .background(Color(red: 102/255, green: 103/255, blue: 171/255))
        //로그아웃 팝업 알림
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
    

//struct ProfileView_Previews: PreviewProvider{
//    static var previews: some View{
//        ProfileView(userName: "동길홍", userNext: "13:40", userImg: "None")
//    }
//}
}
