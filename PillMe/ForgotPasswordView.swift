//
//  ForgotPasswordView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/15.
//

import SwiftUI

struct ForgotPasswordView: View{
    @State var ID: String = ""
    @State var TELL: String = ""

    @State private var shouldShowAlert : Bool = false
    @State private var popupText : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View
    {
        ZStack{
            //배경색
            Color(red: 102/255, green: 103/255, blue: 171/255)
                .edgesIgnoringSafeArea(.all)
            VStack{
                //비밀번호 찾기
                Text("Find password")
                    .foregroundColor(Color.white)
                    .font(.system(size:45))
                //아이디 입력
                HStack{
                    TextField(" Enter the ID to find", text: $ID)
                        .frame(width: .infinity, height: 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .keyboardType(.default)
                }
                .padding()
                
                //전화번호
                HStack{
                    TextField(" Enter your phone number", text: $TELL)
                        .frame(width: .infinity, height: 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .keyboardType(.default)
                }
                .padding()
                
                //찾기 버튼
                Button(action: {
                    var findPW = PasswordManager.pwManager
                    findPW.run = true
                    var find = findPW.findPW(userID: ID, userTel: TELL)
                    if find != ""
                    {
                        presentationMode.wrappedValue.dismiss()
                        shouldShowAlert = true
                        popupText = "당신의 비밀번호는"+find+"입니다."
                    }
                    else
                    {
                        shouldShowAlert = true
                        popupText = "입력한 정보에대한 비밀번호를 찾을 수 없습니다.!"
                    }
                }) {
                    //버튼 그리기
                    VStack{
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(red:188/255, green: 191/255, blue:240/255))
                            .frame(height: 70)
                            .overlay(
                                
                                Text("Find password")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .font(.system(size:25))
                                )
                    }
                    .padding()
                }
            }
            .onAppear (perform : UIApplication.shared.hideKeyboard)
        }.alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
}

struct ForgotPasswordView_Previews: PreviewProvider{
    static var previews: some View{
        ForgotPasswordView()
    }
}
