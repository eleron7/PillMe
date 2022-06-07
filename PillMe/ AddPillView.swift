//
//  AddPill.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/15.
//
import Foundation

import SwiftUI

//DateToString
func GetDateToString(date:Date, format:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
    return dateFormatter.string(from: date)
}

struct AddPillView : View{
    var times = ["한번", "두번", "세번", "네번"]
    var eats = ["식전", "식후"]
    var time = ["한번", "두번", "세번", "네번"]
    
    @State var EatingTimes = Array(1...4).map {"목록\($0)"}
    
    let colums = [
        GridItem(.adaptive(minimum: 100))
    ]
    @State var PillMaster : String
    
    @State var selectedTime = 0
    @State var selectedEat = 0
    @State var timeString : String = ""

    //약먹는 시간(최대 4개)를 저장하는 배열
    @State private var DateArray : [Date] = [Date()]
    @State private var DateStringArray : [String] = []
    @State var moduleNum: String = ""
    @State var pillName: String = ""

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
                    RoundedRectangle(cornerRadius: 55)
                        .fill(Color(red:188/255, green: 191/255, blue:240/255))
                        .frame(width: 200, height: 200)
                        .padding()
                        .overlay(Image(
                            systemName: "pills.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color.white)
                        )
                    
                    //모듈번호
                    TextField(" Module Num", text: $moduleNum)
                        .frame(width: .infinity, height: 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .keyboardType(.default)
                        .padding()
                    
                    //약이름
                    TextField(" Pill Name", text: $pillName)
                        .frame(width: .infinity, height: 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .keyboardType(.default)
                        .padding()
                    
                    //복용주기(피커)
                    HStack{
                        
                        Text("복용횟수")
                            .font(.system(size:25))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        //횟수
                        Menu{
                            Picker(selection: $selectedTime){
                                ForEach(0..<times.count, id:\.self) { index in
                                    Text(times[index])
                                }
                            } label: {}
                        } label: {
                            Text(times[selectedTime])
                                .font(.system(size:25))
                        }
                        .foregroundColor(Color(red:188/255, green: 191/255, blue:240/255))
                        .onChange(of: selectedTime){ value in
                            if DateArray.count < selectedTime+1
                            {
                                while DateArray.count != selectedTime+1
                                {
                                    DateArray.append(Date())
                                }
                            }
                            else if DateArray.count > selectedTime+1
                            {
                                while DateArray.count != selectedTime+1
                                {
                                    DateArray.popLast()
                                }
                            }
                        }
                        
                        //식전, 식후
                        Menu{
                            Picker(selection: $selectedEat){
                                ForEach(0..<eats.count, id:\.self) { index in
                                    Text(eats[index])
                                }
                            } label: {}
                        } label: {
                            Text(eats[selectedEat])
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
                //약 등록버튼
                Button(action: {
                    var addPillManager = AddPillManager.addPillManager
                    var addTimeManager = AddTimeManager.addTimeManager
                    addTimeManager.run = true
                    
                    var i = 0
                    for value in DateArray{
                        addTimeManager.addTime(moduleNum: moduleNum, pillName: pillName, pillMaster: PillMaster, eatTime: GetDateToString(date:value, format: "HH:mm"))
                        
                        if i == selectedTime
                        {
                            break
                        }
                        i = i + 1
                    }
                    
                    addPillManager.run = true
                    addPillManager.addPillInfo(modulenum: moduleNum, pillMaster: PillMaster, pillname: pillName, times: String(selectedTime), eat: String(selectedEat))
                    
                    //알림수정
                    var localNotificationManager = LocalNotificationManager.localNotificationManager
                    localNotificationManager.run = true
                    localNotificationManager.editNotification(userName: self.PillMaster)
                    
                    presentationMode.wrappedValue.dismiss()
                    shouldShowAlert = true
                    popupText = "등록 완료!"
                }) {
                    //버튼 그리기
                    VStack{
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(red:188/255, green: 191/255, blue:240/255))
                            .frame(height: 70)
                            .overlay(
                                Text("registration")
                                    .fontWeight(.bold)
                                    .font(.system(size:30))
                                    .foregroundColor(Color.white)
                            )
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text("알림"), message: Text("\(popupText)"),
                  dismissButton: .default(Text("확인")))
        })
    }
}

struct AddPillView_Previews: PreviewProvider{
    static var previews: some View{
        AddPillView(PillMaster: "")
    }
}
