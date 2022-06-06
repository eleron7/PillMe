//
//  LoginView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/06.
//

import SwiftUI

struct LoginView: View{
    
    @State var ID: String = UserDefaults.standard.string(forKey: "ID") ?? ""
    @State var PW: String = UserDefaults.standard.string(forKey: "PW") ?? ""
    @State var NAME: String = ""
    @State var loginOK : Bool = false
    
    init() {
        UISwitch.appearance().onTintColor = .green
        UISwitch.appearance().thumbTintColor = .white
    }
    
    var body: some View{
        return NavigationView{
            ZStack{
                //배경색
                Color(red: 102/255, green: 103/255, blue: 171/255)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    //이미지
                    //타이틀
                    Text("PillMe")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                    
                    //ID
                    HStack{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.fill")
                                .font(.system(size:30))
                                .foregroundColor(Color.white)
                            )
                            .cornerRadius(10)
                            .padding(.leading)
                        TextField(" ID / E-mail Address", text: $ID)
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.trailing)
                            .keyboardType(.default)
                    }
                    
                    //Paasword
                    HStack{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "key.fill")
                                .font(.system(size:30))
                                .foregroundColor(Color.white)
                            )
                            .cornerRadius(10)
                            .padding(.leading)
                        SecureField(" Password", text: $PW)
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.trailing)
                            .keyboardType(.default)
                    }
                    
                    //로그인 버튼
                    LoginAction
                    
                    //guideText
                    VStack{
                        SignupAction
                        searchPasswordAction
                    }.padding()
                }
                .onAppear (perform : UIApplication.shared.hideKeyboard)
            }.onAppear(perform: {
                var loginManager = LoginManager.loginManaer
                var LoginResult : Bool = false
                loginManager.run = true//비동기처리 트리거
                LoginResult = loginManager.login(userID: self.ID, userPW: self.PW)
                NAME = loginManager.loginName
                
                if LoginResult
                {
                    loginOK = true
                    UserDefaults.standard.set(self.ID, forKey: "ID")
                    UserDefaults.standard.set(self.PW, forKey: "PW")
                }
                else
                {
                    loginOK = false
                }
            })
        }
    }
}

private extension LoginView{
    var LoginAction: some View{//로그인 액션
        NavigationLink(destination: TabView(tabIndex: .PillManage, loginUserID: ID, loginUserNAME: NAME) //아이디와 비밀번호가 같은가 ? 일치한다면 로그인 : 아니라면 Alert
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true), isActive: $loginOK)
        {
            Text("Login")//로그인 버튼
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(width: 200, height: 60)
                .background(Color(red: 188/255, green: 191/255, blue: 240/255))
                .cornerRadius(40)
                .padding()
                .onTapGesture {
                    var loginManager = LoginManager.loginManaer
                    var LoginResult : Bool = false
                    loginManager.run = true//비동기처리 트리거
                    LoginResult = loginManager.login(userID: ID, userPW: PW)
                    NAME = loginManager.loginName
                    print(LoginResult)
                    
                    if LoginResult
                    {
                        loginOK = true
                        UserDefaults.standard.set(self.ID, forKey: "ID")
                        UserDefaults.standard.set(self.PW, forKey: "PW")
                    }
                    else
                    {
                        loginOK = false
                    }
                }
                
        }
    }
    
    var SignupAction: some View{//회원가입 액션
        NavigationLink(destination: SignupView()
            .navigationBarTitle("", displayMode: .inline)){
            Text("signup")//회원가입 버튼
                .foregroundColor(Color.blue)
                .padding()
        }
    }
    
    var searchPasswordAction: some View{//비밀번호 찾기 액션
        NavigationLink(destination: ForgotPasswordView()
            .navigationBarTitle("", displayMode: .inline)){
            Text("forgot your password?")//비밀번호 찾기 버튼
                .foregroundColor(Color.blue)
        }
    }
}


struct LoginView_Previews: PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}

