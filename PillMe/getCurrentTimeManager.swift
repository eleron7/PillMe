//
//  DBManager.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/20.
//

import Foundation
import SwiftUI

class getCurrentTimeManager {
    static let currentTimeManager = getCurrentTimeManager()
    var pillTime : [pillTimeModel] = []
    var loginOK : Bool
    var loginName : String = ""
    var run = true
    //생성자
    init() {
        loginOK = false
    }
    
    //현재시간과 가장 가까운 약 먹는 시간을 반환하는 연산
    func getCurrentTime(pillMaster: String) -> [pillTimeModel]
    {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var currentTime = formatter.string(from: Date())
        var query = "SELECT * FROM PillMe.PillTime as A WHERE (TIME_TO_SEC('"+currentTime+"') - TIME_TO_SEC(EatTime))/60 <= 30 AND PillMaster = '"+pillMaster+"'  AND NOT EXISTS ( SELECT *, DATE_FORMAT(PillTakeTime, '%H:%i'), (TIME_TO_SEC(DATE_FORMAT(PillTakeTime, '%H:%i')) - TIME_TO_SEC(A.EatTime))/60 FROM PillMe.PillTake WHERE DATE_FORMAT(PillTakeTime, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d') AND ModuleNum = A.ModuleNum AND (TIME_TO_SEC(DATE_FORMAT(PillTakeTime, '%H:%i')) - TIME_TO_SEC(A.EatTime))/60 <= 30 AND (TIME_TO_SEC(DATE_FORMAT(PillTakeTime, '%H:%i')) - TIME_TO_SEC(A.EatTime))/60 >= 0) ORDER BY EatTime ASC"

        //쿼리스트링을 swift에서 php 서버로 전송하여 요청
        let url = "http://"+serverUrl+"/pillmeGetData.php"
        var components = URLComponents(string: url)
        //실제 php API에서 Mysql서버로 요청할 쿼리
        var myQuery = URLQueryItem(name: "myQuery", value: query)
        components?.queryItems = [myQuery]
    
        //guard문 --> 해당 url이 존재한다면 그 url을 반환 아니라면 애러문 출력
        guard let url: URL = components?.url else{
            print("invalid URL")
            return pillTime
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
            print("시간 데이터를 성공적으로 다운로드 했습니다!")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
                    
            do{
                self.pillTime = try JSONDecoder().decode( [pillTimeModel].self, from: data )
            } catch {
                print(error.localizedDescription)
            }
            
            //while동작을 위한 트리거
            self.run = false

        }).resume()
        //로그인 동기처리를 위한 while문
        while run {}
        return self.pillTime
    }
}


