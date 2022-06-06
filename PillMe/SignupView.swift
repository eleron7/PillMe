import SwiftUI

struct SignupView: View{

    @State var ID: String = ""
    
    @State var PW1: String = ""
    @State var PW2: String = ""
    @State var checkTextPW: String = ""
    @State var checkTextColorPW: Color = Color.red
    
    @State var NAME: String = ""
    @State var checkTextNAME: String = ""

    @State var TELL: String = ""
    @State var checkTextTELL: String = ""

    @State private var shouldShowAlert : Bool = false
    @State private var popupText : String = ""
    @Environment(\.presentationMode) var presentationMode

    @State var idCheck:Bool = false
    @State var passwordCheck:Int = 0
    
    var body: some View{
        ZStack{
            //배경색
            Color(red: 102/255, green: 103/255, blue: 171/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView{
                    Text("Signup for PillMe")
                        .foregroundColor(Color.white)
                        .font(.system(size:45))
                    //아이디 입력
                    HStack{
                        TextField(" ID", text: $ID)
                            .onChange(of: ID, perform: { value in
                                idCheck = isValidId(id: value)
                            })
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .keyboardType(.default)
                        Button(action: {
                            var idCheckManager = IdCheckManager.idCheckManager
                            idCheckManager.run = true
                        //중복확인
                            shouldShowAlert = true
                            if idCheckManager.idCheck(userID: ID)
                            {
                                popupText="이미 사용중인 아이디 입니다."
                            }
                            else if !isValidId(id: ID)
                            {
                                popupText="사용가능한 아이디 형식이 아닙니다!\n (대소영문자 4~13 자리)"
                            }
                            else
                            {
                                popupText="사용가능한 아이디 입니다!"
                            }
                        }) {
                            VStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red:188/255, green: 191/255, blue:240/255))
                                    .frame(width: 100, height: 50)
                                    .overlay(
                                        Text("ID check")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .font(.system(size:20))
                                    )
                            }
                        }
                    }
                    .padding()
                    
                    //비밀번호
                    HStack{
                        TextField(" PASSWORD", text: $PW1)
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .keyboardType(.default)
                    }
                    .padding()
                    
                    //비밀번호 확인
                    HStack{
                        TextField(" PASSWORD CHECK", text: $PW2)
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .keyboardType(.default)
                            .onChange(of: PW2) { value in
                                if checkPW(userPW1: PW1, userPW2: value) == 1
                                {
                                    checkTextPW = "password must be at least 6"
                                    checkTextColorPW = Color.red
                                }
                                
                                else if checkPW(userPW1: PW1, userPW2: value) == 2
                                {
                                    checkTextPW = "password is diffrent!"
                                    checkTextColorPW = Color.red
                                }
                                
                                else
                                {
                                    checkTextPW = "password match!"
                                    checkTextColorPW = Color.green
                                }
                            }
                    }
                    .padding()
                    
                    Text(checkTextPW)
                        .foregroundColor(checkTextColorPW)
                  
                    //이름
                    HStack{
                        TextField(" NAME", text: $NAME)
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .keyboardType(.default)
                            .onChange(of: NAME) { value in
                                if !isValidName(Name: value)
                                {
                                    checkTextNAME = "name format is invalid"
                                }
                                else
                                {
                                    checkTextNAME = ""
                                }
                            }
                    }
                    .padding()
                    
                    Text(checkTextNAME)
                        .foregroundColor(Color.red)

                    
                    //전화번호
                    HStack{
                        TextField(" TEL", text: $TELL)
                            .frame(width: .infinity, height: 50)
                            .background(Color.white)
                            .cornerRadius(15)
                            .keyboardType(.default)
                            .onChange(of: TELL) { value in
                                if !isValidPhone(phone: value)
                                {
                                    checkTextTELL = "tel format is invalid"
                                }
                                else
                                {
                                    checkTextTELL = ""
                                }
                            }
                    }
                    .padding()
                }
                
                Text(checkTextTELL)
                    .foregroundColor(Color.red)
                
                //회원가입 버튼
                Button(action: {
                    //회원가입
                    var idCheckManager = IdCheckManager.idCheckManager
                    idCheckManager.run = true
                    if !idCheckManager.idCheck(userID: ID)&&isValidId(id: ID)&&(checkPW(userPW1: PW1, userPW2: PW2)==3)&&isValidName(Name: NAME)&&isValidPhone(phone: TELL)
                    {
                        var signupManager = SignupManager.signupManager
                        signupManager.run = true
                        signupManager.signup(userID: ID, userPW: PW1, userNAME: NAME, userTEL: TELL)
                        presentationMode.wrappedValue.dismiss()
                        shouldShowAlert = true
                        popupText = "회왼가입 완료!"
                    }
                    
                }) {
                    //버튼 그리기
                    VStack{
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(red:188/255, green: 191/255, blue:240/255))
                            .frame(height: 70)
                            .overlay(
                                
                                Text("Signup")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .font(.system(size:25))
                                )
                    }
                    .padding()
                }
            }.onAppear (perform : UIApplication.shared.hideKeyboard)
            //로그아웃 팝업 알림
        }.alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
}

func checkPW(userPW1: String, userPW2:String) -> Int{
    if !isValidPw(pw: userPW1)
    {
        return 1// "비밀번호는 대문자 소문자 숫자 6자리의 조합만 가능합니다."
    }
    else
    {
        if userPW1 != userPW2
        {
            return 2// "비밀번호가 일치하지 않습니다."
        }
        return 3// "비밀번호 사용가능"
    }
}

//ID 정규식
func isValidId(id: String?) -> Bool {
        guard id != nil else { return false }

        let idRegEx = "[A-Za-z0-9]{4,13}"//대소영문자 4~13 자리
        let pred = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return pred.evaluate(with: id)
}

//PW 정규식
func isValidPw(pw: String?) -> Bool {
        guard pw != nil else { return false }

        let pwRegEx = "[A-Za-z0-9]{6,20}"//대소영문자 6~20 자리
        let pred = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return pred.evaluate(with: pw)
}

//NAME 정규식
func isValidName(Name: String?) -> Bool {
        guard Name != nil else { return false }

        let nickRegEx = "[가-힣A-Za-z0-9]{2,7}"//한글 대소영문자 2~7 자리
        let pred = NSPredicate(format:"SELF MATCHES %@", nickRegEx)
        return pred.evaluate(with: Name)
}

//TEL 정규식
func isValidPhone(phone: String?) -> Bool {
        guard phone != nil else { return false }

        let phoneRegEx = "[0-9]{11}"//0~9사이에 11자리
        let pred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return pred.evaluate(with: phone)
}


struct SignupView_Previews: PreviewProvider{
    static var previews: some View{
        SignupView()
    }
}
