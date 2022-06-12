//
//  DBManager.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/20.
//

import Foundation
import SwiftUI
import UserNotifications

//NotificationManager
class NotificationManager{
    static let instance = NotificationManager()

    //알림권한요청
    func requestAuthorization()
    {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error{ print("ERROR: \(error)") }
            else{ print("SUCCESS") }
        }
    }

    //푸시 알림 생성
    func scheduleNotifiation(pillName:String, pillTime:String){
        let content = UNMutableNotificationContent()
        
        var PillTimeString = pillTime.components(separatedBy: ":")//:를 기준으로 분과 시간을 분리
        
        var selectHour = PillTimeString[0]
        var selectMinute = PillTimeString[1]
        var identi = pillName + "-" + pillTime
        content.title = "PillMe"
        content.subtitle = identi//약 이름과 약먹을 시간
        
        content.sound = .default
        content.badge = 0
        
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: Int(selectHour), minute: Int(selectMinute)), repeats: false)
        let request = UNNotificationRequest(
            identifier: identi,//알림의 식별자를 통해 이것을 취소할 수 있음
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("add Notification : "+String(selectHour)+":"+String(selectMinute));
    }
}

//LocalNotificationManager
class LocalNotificationManager {
    static let localNotificationManager = LocalNotificationManager()
    var result : [pillTimeModel] = []
    var run = true
    //생성자
    init() {
    }
    
    //DB에 사용자 이름에 해당하는 약들의 시간을 받아서 알림을 수정
    func editNotification(userName: String)
    {
        var query = "SELECT * FROM PillMe.PillTime WHERE PillMaster = '"+userName+"'"

        //쿼리스트링을 swift에서 php 서버로 전송하여 요청
        let url = "http://"+serverUrl+"/pillmeGetData.php"
        var components = URLComponents(string: url)
        //실제 php API에서 Mysql서버로 요청할 쿼리
        var searchData = URLQueryItem(name: "myQuery", value: query)
        print(query)
        components?.queryItems = [searchData]
    
        //guard문 --> 해당 url이 존재한다면 그 url을 반환 아니라면 애러문 출력
        guard let url: URL = components?.url else{
            print("invalid URL")
            return
        }
        
        //위에서 확인한 url로 GET 방식으로 요청
        var urlRequst: URLRequest = URLRequest(url: url)
        urlRequst.httpMethod = "POST"
        URLSession.shared.dataTask(with: urlRequst, completionHandler: { (data, response, error) in
            //데이터 확인
            guard let data = data else {
                print("데이터가 존재하지 않습니다.")
                return
            }
            
            //오류 확인
            guard error == nil else {
                print("오류 : \(String(describing:error))")
                return
            }
            
            //http 응답을 받음
            guard let response = response as? HTTPURLResponse else {
                print("잘못된 응답입니다.")
                return
            }
            
            //응답 상태
            guard response.statusCode >= 200 && response.statusCode < 300 else{
                print("Status Code는 2xx이 되야 합니다. 현재 Status Code는 \(response.statusCode) 입니다.")
                return
            }
            print("약검색 데이터를 성공적으로 다운로드 했습니다!")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
                    
            do{
                self.result = try JSONDecoder().decode( [pillTimeModel].self, from: data )
            } catch {
                print(error.localizedDescription)
            }
            print("check!")

            //while동작을 위한 트리거
            self.run = false
            
            //우선 기존 알림 모두 삭제
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            //사용자로부터 알림 요청을 받음
            NotificationManager.instance.requestAuthorization()
            
            //갱신된 DB기반으로 알림 재등록
            for value in self.result{
                NotificationManager.instance.scheduleNotifiation(pillName: value.PillName.unsafelyUnwrapped, pillTime: value.EatTime.unsafelyUnwrapped)
            }
            
        }).resume()
        //로그인 동기처리를 위한 while문
        while run {}
    }
}


