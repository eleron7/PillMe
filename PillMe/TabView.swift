//
//  TabView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/04/16.
//

import Foundation

import SwiftUI

enum TabIndex{
    case PillManage, Chart, PillInfo
}

struct TabView : View{
    @State var tabIndex : TabIndex
    @State var loginUserID: String
    @State var loginUserNAME: String
    @State var NextPillTime : String = ""
    @State var largerScale : CGFloat = 1.4
    @State var pillResult : [pillModel] = []
    
    //탭뷰 선택을 통해 뷰를 바꾸는 함수
    
    func changeView(tabIndex: TabIndex) -> some View{
        switch tabIndex {
        case .PillManage:
            return AnyView(mainView(loginUserID: loginUserID, loginUserNAME: loginUserNAME, pillResult: $pillResult))
        case .Chart:
            return AnyView(FriendView(userID: loginUserID))
        case .PillInfo:
            return AnyView(PillSearchView())
        default:
            return AnyView(mainView(loginUserID: loginUserID, loginUserNAME: loginUserNAME, pillResult: $pillResult))
        }
    }
    
    //선택된 뷰에 따라 탭서클의 위치가 바뀌는 함수
    func calcCirclePosition(tabIndex: TabIndex, geometry : GeometryProxy) -> CGFloat{
        switch tabIndex {
        case .PillManage:
            return -(geometry.size.width/3)
        case .Chart:
            return 0
        case .PillInfo:
            return geometry.size.width/3
        default:
            return -(geometry.size.width/3)
        }
    }
    
    var body : some View{
        ZStack{
            Color(red: 102/255, green: 103/255, blue: 171/255)
                .edgesIgnoringSafeArea(.all)
            VStack{
                //1.프로필뷰
                ProfileView(userID: loginUserID ,userName: loginUserNAME)
                    
                //2.선택된 뷰를 그림
                GeometryReader{
                    geometry in
                    ZStack(alignment: .bottom){
                        self.changeView(tabIndex: self.tabIndex)
                        
                        Circle()
                            .frame(width: 90, height: 90)
                            .offset(x: self.calcCirclePosition(tabIndex: self.tabIndex , geometry: geometry),y: UIApplication.shared.windows.first? .safeAreaInsets.bottom == 0 ? 20 : 0)
                            .foregroundColor(Color.white)
                            
                        VStack(spacing: 0){
                            HStack(spacing: 0){
                                Button(action:{
                                    print("약 버튼 클릭")
                                    withAnimation{
                                        self.tabIndex = .PillManage
                                    }
                                }){
                                    Image(systemName: "pills.fill")
                                        .font(.system(size:25))
                                        .scaleEffect(self.tabIndex == .PillManage ? self.largerScale : 1.0)
                                        .foregroundColor(self.tabIndex == .PillManage ? Color(red: 102/255, green: 103/255, blue: 171/255) : Color.gray)
                                        .frame(width: geometry.size.width / 3, height: 50)
                                        .offset(y: self.tabIndex == .PillManage ? -10 : 0)
                                }.background(Color.white)
                                
                                Button(action:{
                                    print("프로필 버튼 클릭")
                                    withAnimation{
                                        self.tabIndex = .Chart
                                    }
                                }){
                                    Image(systemName: "person.text.rectangle")
                                        .font(.system(size:25))
                                        .scaleEffect(self.tabIndex == .Chart ? self.largerScale : 1.0)
                                        .foregroundColor(self.tabIndex == .Chart ? Color(red: 102/255, green: 103/255, blue: 171/255) : Color.gray)
                                        .frame(width: geometry.size.width / 3, height: 50)
                                        .offset(y: self.tabIndex == .Chart ? -10 : 0)
                                }.background(Color.white)
                                
                                Button(action:{
                                    print("메뉴 버튼 클릭")
                                    withAnimation{
                                        self.tabIndex = .PillInfo
                                    }
                                }){
                                    Image(systemName: "info.circle.fill")
                                        .font(.system(size:25))
                                        .scaleEffect(self.tabIndex == .PillInfo ? self.largerScale : 1.0)
                                        .foregroundColor(self.tabIndex == .PillInfo ? Color(red: 102/255, green: 103/255, blue: 171/255) : Color.gray)
                                        .frame(width: geometry.size.width / 3, height: 50)
                                        .offset(y: self.tabIndex == .PillInfo ? -10 : 0)
                                }.background(Color.white)
                            }//h
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(height: UIApplication.shared.windows.first? .safeAreaInsets.bottom == 0 ? 0 : 20)
                        }//v
                    }
                }.edgesIgnoringSafeArea(.bottom)
            }//v
            .onAppear(perform: {
                var pillManager = PillManager.pillManager
                pillManager.run = true//비동기처리 트리거
                self.pillResult = pillManager.selectPillInfo(userID: loginUserID)
                print("TAB:UI")
            })
        }
        
        
    }
}

//struct TabView_Previews: PreviewProvider{
//    static var previews: some View{
//        TabView(tabIndex: .PillManage, loginUserID: "" , loginUserNAME: "")
//    }
//}
