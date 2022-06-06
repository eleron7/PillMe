//
//  DBManager.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/20.
//

import Foundation
import SwiftUI


class IdCheckManager {
    static let idCheckManager = IdCheckManager()
    var userModels : [userModel] = []
    var IdOK : Bool
    var loginName : String = ""
    var run = true
    //생성자
    init() {
        IdOK = false
    }
    
    //login 함수
    func idCheck(userID: String) -> Bool
    {
        var query = "SELECT * FROM member WHERE userid = '"+userID+"'"
        //쿼리스트링을 swift에서 php 서버로 전송하여 요청
        let url = "http://"+serverUrl+"/pillmeGetData.php"
        var components = URLComponents(string: url)
        //실제 php API에서 Mysql서버로 요청할 쿼리
        var myQuery = URLQueryItem(name: "myQuery", value: query)
        components?.queryItems = [myQuery]
    
        //guard문 --> 해당 url이 존재한다면 그 url을 반환 아니라면 애러문 출력
        guard let url: URL = components?.url else{
            print("invalid URL")
            return IdOK
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
            print("유저 데이터를 성공적으로 다운로드 했습니다!")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
                    
            do{
                print("running")
                self.userModels = try JSONDecoder().decode( [userModel].self, from: data )

                if self.userModels.first?.userID == userID
                {
                    self.IdOK = true
                }
                else
                {
                    self.IdOK = false
                }
            } catch {
                print(error.localizedDescription)
            }
            
            //while동작을 위한 트리거
            self.run = false

        }).resume()
        //로그인 동기처리를 위한 while문
        while run {
            
        }
        
        return self.IdOK
    }
}


