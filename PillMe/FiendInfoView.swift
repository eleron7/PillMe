//
//  FiendInfoView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/16.
//

import SwiftUI

struct FriendInfoView: View{
    
    @State var dateCommponents = DateComponents()
//    @State var date = Calendar.current.date(from: dateCommponents)
    
    @State var year : Int = 0
    @State var month : Int = 0
    @State var day : Int = 0
    
    @State var friendInfoManager = FriendInfoManager.friendInfoManager
    
    @State var userID : String//로그인한 유저 아이디
    @State var friendID : String//친구 아이디
    @State var friendName : String = ""//친구 이름
    
    @State var pillList : [pillModel] = []
    
    @State private var shouldShowAlert : Bool = false
    @State private var popupText : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    let colums = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View{
        ZStack{
            Color(red: 102/255, green: 103/255, blue: 171/255)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    //친구 프로필 사진
                    Circle()
                        .fill(Color(red: 224/255, green: 224/255, blue: 224/255))
                        .frame(width: 150, height: 150, alignment: .center)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size:100))
                                .foregroundColor(Color(red: 95/255, green: 141/255, blue: 172/255)))
                    Spacer()
                    VStack
                    {
                        //친구이름
                        Text(friendName)
                            .fontWeight(.bold)
                            .font(.system(size:30))
                            .foregroundColor(Color.white)
                        
                        //친구삭제 버튼
                        Button(action:{
                            self.friendInfoManager.run2 = true
                            self.friendInfoManager.deleteFriendInfo(userID: userID, friendID: friendID)
                            presentationMode.wrappedValue.dismiss()
                            shouldShowAlert = true
                            popupText = "친구 삭제완료!"
                        })
                        {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red:155/255, green: 89/255, blue:182/255))
                                .frame(width: 120, height: 60)
                                .overlay(
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color.white)
                                )
                        }
                    }
                }.padding()
                
                
                //친구가 복용중인 약 리스트
                VStack{
                    ScrollView{
                        LazyVGrid(columns: colums, spacing: 20){
                            ForEach(self.pillList) {
                                value in VStack{
                                    RoundedRectangle(cornerRadius: 35)
                                        .fill(Color(red:188/255, green: 191/255, blue:240/255))
                                        .frame(height: 100)
                                        .overlay(Image(
                                            systemName: "pills.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color.gray)
                                        )
                                    Text(value.PillName ?? "")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }.padding(.horizontal)
                    }
                }
                
                //켈린더뷰
                VStack {
                    if var date = Calendar.current.date(from: self.dateCommponents) {
                        Text(friendName + "님의 복용현황")
                            .fontWeight(.bold)
                            .font(.system(size:25))
                            .foregroundColor(Color.white)
                        
                        //달력뷰에 약리스트와 현재 날자를 삽입
                        CalendarView(pillList: $pillList, monthToDisplay: date)
                    }
                }.padding()
            }.onAppear(perform: {

                self.friendInfoManager.run1 = true
                self.friendInfoManager.run3 = true
                //친구ID로 이름 가져오기
                self.friendName = self.friendInfoManager.getFriendInfo(friendID: self.friendID).first?.userNAME ?? ""
                //친구ID로 약리스트 가져오기
                self.pillList = self.friendInfoManager.getFriendPillList(friendID: self.friendID)
                
                let now = Date()
                //현재 년 월 일 구하기
                let yearFM = DateFormatter()
                yearFM.dateFormat = "yyyy"
                self.year = Int(yearFM.string(from: now)) ?? 0
                let monthFM = DateFormatter()
                monthFM.dateFormat = "MM"
                self.month = Int(monthFM.string(from: now)) ?? 0
                let dayFM = DateFormatter()
                dayFM.dateFormat = "dd"
                self.day = Int(dayFM.string(from: now)) ?? 0
                
                //달력을 현재 시간으로 바꾸기
                self.dateCommponents = DateComponents(year: self.year, month: self.month, day: self.day)
            })
        }.alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
}

struct FriendInfoView_Previews: PreviewProvider{
    static var previews: some View{
        FriendInfoView(userID: "", friendID: "무명친구")
    }
}
