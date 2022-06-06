//
//  PillSearchView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/15.
//
import Foundation

import SwiftUI

struct PillSearchView: View{
    
    @State private var searchText = ""
    @State private var PRDLST_NM = ""//제품명
    @State private var NTK_MTHD = ""//섭취량 섭취방법
    @State private var PRIMARY_FNCLTY = ""//기능성 내용
    @State private var CSTDY_MTHD = ""//보존 및 유통기준
    @State private var IFTKN_ATNT_MATR_CN = ""//섭취시 주의사항
    @State private var pageNum = 0//페이지 번호
    
    @State var resultPillInfo : [serachPillInfoModel] = []//검색한 데이터
    
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
                SearchBarView(searchType: "pill", text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                /*2.약검색*/
                Button(action:{
                    var searchPillInfoManager = SearchPillInfoManager.searchPillInfoManager
                    searchPillInfoManager.run = true
                    self.resultPillInfo = searchPillInfoManager.searchPillInfo(searchText: searchText)
                    
                    if self.resultPillInfo.count != 0
                    {
                        self.PRDLST_NM = self.resultPillInfo[self.pageNum].PRDLST_NM ?? ""
                        self.NTK_MTHD = self.resultPillInfo[self.pageNum].NTK_MTHD ?? ""
                        self.PRIMARY_FNCLTY = self.resultPillInfo[self.pageNum].PRIMARY_FNCLTY ?? ""
                        self.CSTDY_MTHD = self.resultPillInfo[self.pageNum].CSTDY_MTHD ?? ""
                        self.IFTKN_ATNT_MATR_CN = self.resultPillInfo[self.pageNum].IFTKN_ATNT_MATR_CN ?? ""
                    }

                    if searchText == ""
                    {
                        //공백을 입력한 경우
                        shouldShowAlert = true
                        popupText = "검색할 내용을 입력해주세요"
                        print("111111111111111")
                    }

                    else
                    {
                        //약정보를 출력하는 과정
                        print("333333333333333")
                    }
                    
                }) {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(red: 155/255, green: 89/255, blue: 182/255))
                        .frame(width: .infinity, height: 65)
                        .overlay(
                            Text("search")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .font(.system(size: 40))
                        )
                        .padding()
                }
                
                /*3.약 정보*/
                if self.PRDLST_NM != ""
                {
                    HStack{
//                            VStack{
//                                RoundedRectangle(cornerRadius: 55)
//                                    .fill(Color(red:188/255, green: 191/255, blue:240/255))
//                                    .frame(width: 200, height: 200)
//                                    .overlay(Image(
//                                        systemName: "pills.fill")
//                                        .font(.system(size: 80))
//                                        .foregroundColor(Color.white)
//                                    )
//                                Spacer()
//                            }
//                            Spacer()

                            HStack{
                                Button(action: {
                                    if self.pageNum != 0
                                    {
                                        self.pageNum = self.pageNum - 1
                                        self.PRDLST_NM = self.resultPillInfo[self.pageNum].PRDLST_NM ?? ""
                                        self.NTK_MTHD = self.resultPillInfo[self.pageNum].NTK_MTHD ?? ""
                                        self.PRIMARY_FNCLTY = self.resultPillInfo[self.pageNum].PRIMARY_FNCLTY ?? ""
                                        self.CSTDY_MTHD = self.resultPillInfo[self.pageNum].CSTDY_MTHD ?? ""
                                        self.IFTKN_ATNT_MATR_CN = self.resultPillInfo[self.pageNum].IFTKN_ATNT_MATR_CN ?? ""
                                    }
                                }){
                                    Circle()
                                        .fill(Color(red: 188/255, green: 191/255, blue: 240/255))
                                        .frame(width: 30, height: 65)
                                        .overlay(
                                            Text("<")
                                                .foregroundColor(Color.white)
                                                .fontWeight(.bold)
                                                .font(.system(size: 20))
                                        )
                                        .padding()
                                }
                                
                                ScrollView{
                                    VStack(alignment: .leading){
                                        Text(self.PRDLST_NM)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                        Spacer()
                                        Text("섭취 방법 : " + self.NTK_MTHD)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        Spacer()
                                        Text(self.PRIMARY_FNCLTY)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        Spacer()
                                        Text("보존 및 유통기준 : " + self.CSTDY_MTHD)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        Spacer()
                                        Text("섭취 유의사항 : " + self.IFTKN_ATNT_MATR_CN)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))

                                    }
                                }//scr
                                
                                Button(action: {
                                    if self.pageNum != self.resultPillInfo.count-1
                                    {
                                        self.pageNum = self.pageNum + 1
                                        self.PRDLST_NM = self.resultPillInfo[self.pageNum].PRDLST_NM ?? ""
                                        self.NTK_MTHD = self.resultPillInfo[self.pageNum].NTK_MTHD ?? ""
                                        self.PRIMARY_FNCLTY = self.resultPillInfo[self.pageNum].PRIMARY_FNCLTY ?? ""
                                        self.CSTDY_MTHD = self.resultPillInfo[self.pageNum].CSTDY_MTHD ?? ""
                                        self.IFTKN_ATNT_MATR_CN = self.resultPillInfo[self.pageNum].IFTKN_ATNT_MATR_CN ?? ""
                                    }
                                }){
                                    Circle()
                                        .fill(Color(red: 188/255, green: 191/255, blue: 240/255))
                                        .frame(width: 30, height: 65)
                                        .overlay(
                                            Text(">")
                                                .foregroundColor(Color.white)
                                                .fontWeight(.bold)
                                                .font(.system(size: 20))
                                        )
                                        .padding()
                                }
                            }
                    }.padding()
                }
                
                Spacer()
            }
            
        }.animation(.none)
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
}

struct PillSearchView_Previews : PreviewProvider{
    static var previews: some View{
        PillSearchView()
    }
}
