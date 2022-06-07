//
//  AddPill.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/15.
//
import Foundation

import SwiftUI

//StringToDate
func getStringToDate(strDate:String, format:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
    return dateFormatter.date(from: strDate)!
}

//DateToString
func getDateToString(date:Date, format:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
    return dateFormatter.string(from: date)
}

struct PillInfoView : View{
    var times = ["한번", "두번", "세번", "네번"]//복용 옵션1
    var eats = ["식전", "식후"]//복용 옵션2
    
    @State var pillData : pillModel//각 약의 정보를 받는 배열
    
    //그리드뷰 최대 컬럼 갯수
    let colums = [ GridItem(.adaptive(minimum: 100)) ]
    var i  : Int = 0
    @State var moduleNum: String = ""
    @State var pillMaster: String = ""
    @State var pillName: String = ""
    @State var pillAmount: String = ""
    @State var pillTime: String = ""
    @State var pillTimeArray: [String] = []
    @State var pillEat: String = ""
    
    @State var timeString : String = ""
    
    @State var pillAmountInt: Int = 0
    @State var pillTimeInt: Int = 0//복용 횟수
    @State var pillEatInt: Int = 0
    
    //약먹는 시간(최대 4개)를 저장하는 배열
    @State private var DateArray : [Date] = []
    @State private var DateStringArray : [String] = []

    @State private var shouldShowAlert : Bool = false
    @State private var popupText : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        ZStack{
            //배경색
            Color(red: 102/255, green: 103/255, blue: 171/255)
                .edgesIgnoringSafeArea(.all)
            VStack{
            ScrollView{
                    HStack
                    {
                        RoundedRectangle(cornerRadius: 55)
                            .fill(Color(red:188/255, green: 191/255, blue:240/255))
                            .frame(width: 150, height: 150)
                            .padding()
                            .overlay(Image(
                                systemName: "pills.fill")
                                .font(.system(size: 80))
                                .foregroundColor(Color.white)
                            )
                        
                        if pillAmountInt >= 75
                        {
                            Image(systemName: "battery.100")
                                .font(.system(size: 70))
                                .foregroundColor(Color.green)
                                .rotationEffect(.degrees(270))
                        }

                        else if pillAmountInt >= 50
                        {
                            Image(systemName: "battery.75")
                                .font(.system(size: 70))
                                .foregroundColor(Color.yellow)
                                .rotationEffect(.degrees(270))
                        }
                        
                        else if pillAmountInt >= 25
                        {
                            Image(systemName: "battery.50")
                                .font(.system(size: 70))
                                .foregroundColor(Color.orange)
                                .rotationEffect(.degrees(270))
                        }
                        
                        else if pillAmountInt != 0
                        {
                            Image(systemName: "battery.25")
                                .font(.system(size: 70))
                                .foregroundColor(Color.red)
                                .rotationEffect(.degrees(270))
                        }
                        
                        else
                        {
                            Image(systemName: "battery.0")
                                .font(.system(size: 70))
                                .foregroundColor(Color.gray)
                                .rotationEffect(.degrees(270))
                        }
                    }
                    
                    //모듈번호
                    HStack{
                        Text("module : ")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 188/255, green: 191/255, blue: 240/255))
                        Text(moduleNum)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                    }
                    .padding()
                
                    //약이름
                    HStack{
                        Text("name : ")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 188/255, green: 191/255, blue: 240/255))
                        Text(pillName)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                    }
                    .padding()
                
                    //복용주기(피커)
                    HStack{
                        Text("복용횟수")
                            .font(.system(size:25))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        //횟수
                        Menu{
                            Picker(selection: $pillTimeInt){
                                ForEach(0..<times.count, id:\.self) { index in
                                    Text(times[index])
                                }
                            } label: {}
                        } label: {
                            Text(times[pillTimeInt])
                                .font(.system(size:25))
                        }
                        .foregroundColor(Color(red:188/255, green: 191/255, blue:240/255))
                        .onChange(of: pillTimeInt){ value in
                            if DateArray.count < pillTimeInt+1
                            {
                                while DateArray.count != pillTimeInt+1
                                {
                                    DateArray.append(Date())
                                }
                            }
                            else if DateArray.count > pillTimeInt+1
                            {
                                while DateArray.count != pillTimeInt+1
                                {
                                    DateArray.popLast()
                                }
                            }
                        }
                        
                        //식전, 식후
                        Menu{
                            Picker(selection: $pillEatInt){
                                ForEach(0..<eats.count, id:\.self) { index in
                                    Text(eats[index])
                                }
                            } label: {}
                        } label: {
                            Text(eats[pillEatInt])
                                .font(.system(size:25))
                        }
                        .foregroundColor(Color(red:188/255, green: 191/255, blue:240/255))
                    }
                    .padding()
                    
                    //복용시간(데이트 피커)
                    Text("시간")
                        .font(.system(size:25))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)

                ForEach($DateArray, id: \.self) { value in
                    DatePicker("", selection: value, displayedComponents: .hourAndMinute)
                        .colorInvert()
                        .labelsHidden()
                        .onAppear(perform: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            DateStringArray.append(dateFormatter.string(from: value.wrappedValue))
                        })
                        .onChange(of: DateArray){ value in
                            DateArray.sort()
                        }
                }
            }
                HStack{
                    //약정보 수정 버튼
                    Button(action: {
                        //삭제하고
                        var deletePillInfo = PillDelteManager.pillDeleteManager
                        deletePillInfo.run = true
                        deletePillInfo.deletePillInfo(modulenum: moduleNum)
                        
                        //삽입
                        var addPillManager = AddPillManager.addPillManager
                        var addTimeManager = AddTimeManager.addTimeManager
                        addTimeManager.run = true
                        
                        var i = 0
                        for value in DateArray{
                            addTimeManager.addTime(moduleNum: moduleNum, pillName: pillName, pillMaster: pillMaster, eatTime: GetDateToString(date:value, format: "HH:mm"))
                            
                            if i == pillTimeInt
                            {
                                break
                            }
                            i = i + 1
                        }
                        
                        addPillManager.run = true
                        addPillManager.addPillInfo(modulenum: moduleNum, pillMaster: pillMaster, pillname: pillName, times: String(pillTimeInt), eat: String(pillEatInt))
                        
                        //알림수정
                        var localNotificationManager = LocalNotificationManager.localNotificationManager
                        localNotificationManager.run = true
                        localNotificationManager.editNotification(userName: self.pillMaster)
                        
                        presentationMode.wrappedValue.dismiss()
                        shouldShowAlert = true
                        popupText = "변경 완료!"
                    }) {
                        VStack{
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(red:188/255, green: 191/255, blue:240/255))
                                .frame(height: 70)
                                .overlay(
                                    Text("SAVE")
                                        .fontWeight(.bold)
                                        .font(.system(size:30))
                                        .foregroundColor(Color.white)
                                )
                        }
                    }
                    
                    //약정보 삭제 버튼
                    Button(action: {
                        var pillDeleteManager = PillDelteManager.pillDeleteManager
                        pillDeleteManager.run = true
                        pillDeleteManager.deletePillInfo(modulenum: moduleNum)
                        
                        //알림수정
                        var localNotificationManager = LocalNotificationManager.localNotificationManager
                        localNotificationManager.run = true
                        localNotificationManager.editNotification(userName: self.pillMaster)
                        
                        presentationMode.wrappedValue.dismiss()
                        shouldShowAlert = true
                        popupText = "삭제 완료!"
                    }) {
                        VStack{
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(red:188/255, green: 191/255, blue:240/255))
                                .frame(height: 70)
                                .overlay(
                                    Text("DELETE")
                                        .fontWeight(.bold)
                                        .font(.system(size:30))
                                        .foregroundColor(Color.white)
                                )
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: {
            self.moduleNum = self.pillData.ModuleNum ?? "" //약통 묘듈
            self.pillMaster = self.pillData.PillMaster ?? "" //약통 주인
            self.pillName = self.pillData.PillName ?? "" //약통 이름
            self.pillAmount = self.pillData.PillAmount ?? "" //약통 잔량
            self.pillTime = self.pillData.PillTime ?? "" //하루에 몇번
            self.pillTimeArray = self.pillTime.components(separatedBy: ",")
            self.pillEat = self.pillData.PillEat ?? "" //식전 식후
            
            //각 양 횟수는 수치로 피커뷰로 나타냄
            self.pillAmountInt = Int(self.pillAmount)!
            self.pillTimeInt = Int(self.pillTime)!
            self.pillEatInt = Int(self.pillEat)!

            var selectTimeManager = SelectTimeManager.selectTimeManager
            selectTimeManager.run = true
            var selectTimeResult = selectTimeManager.getPillTime(moduleNum: self.moduleNum)
            
            for value in selectTimeResult{
                self.DateArray.append(getStringToDate(strDate: value.EatTime ?? "", format: "HH:mm"))
            }
        })
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
}


//struct PillInfoView_Previews: PreviewProvider{
//    static var previews: some View{
//        PillInfoView(pillData: nil)
//    }
//}
