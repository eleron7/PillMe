//
//  mainView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/04/16.
//

import SwiftUI

struct mainView : View{
    @State var loginUserID: String
    @State var loginUserNAME: String
    @Binding var pillResult : [pillModel]

    //그리드뷰 최대 컬럼 갯수
    let colums = [ GridItem(.adaptive(minimum: 100)) ]
    
    var body: some View{
            ZStack{
                Color(red: 102/255, green: 103/255, blue: 171/255)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    /*약 리스트*/
                    ScrollView{
                        LazyVGrid(columns: colums, spacing: 20){
                            ForEach(self.pillResult) { result in
                                VStack{
                                    NavigationLink(destination: PillInfoView(pillData: result)){
                                            RoundedRectangle(cornerRadius: 35)
                                                .fill(Color(red:188/255, green: 191/255, blue:240/255))
                                                .frame(height: 100)
                                                .overlay(Image(
                                                    systemName: "pills.fill")
                                                    .font(.system(size: 50))
                                                    .foregroundColor(Color.gray)
                                                )
                                    }
                                    Text(result.PillName ?? "")
                                        .foregroundColor(.secondary)
                                }
                            }
                            /*추가버튼*/
                            AddPillAction
                        }.padding(.horizontal)
                    }
            }.animation(.none)
            .onAppear(perform: {
                print("main:UI")
//                var pillManager = PillManager.pillManager
//                pillManager.run = true//비동기처리 트리거
//                self.pillResult = pillManager.selectPillInfo(userID: loginUserID)
                
            })
        }
    }
}

private extension mainView{
    var AddPillAction: some View{//약추가 액션
        NavigationLink(destination: AddPillView(PillMaster: loginUserID)){
                VStack{
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(red:188/255, green: 191/255, blue:240/255))
                        .opacity(0.5)
                        .frame(height: 100)
                        .overlay(Image(
                            systemName: "plus.app")
                            .font(.system(size: 60))
                            .foregroundColor(Color.white)
                        )
                    Text("추가")
                        .foregroundColor(.secondary)
            }
        }
    }
}

//struct mainView_Previews: PreviewProvider{
//    static var previews: some View{
//        mainView(loginUserID: "", loginUserNAME: "")
//    }
//}
