
//
//  PillManager.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/21.
//

import Foundation
import SwiftUI

class AddFriendManager {
    static let addFriendManager = AddFriendManager()
    var checkMemberResult : [userModel] = []
    var checkFriendResult : [FriendListModel] = []

    var run1 = true
    var run2 = true
    var run3 = true
    //생성자
    init() {
    }
    
    //검색한 맴버가 있는지 확인하는 함수
    func MemberCheck(searchID: String) -> [userModel]{
        var query = "SELECT * FROM member WHERE userID = '"+searchID+"'"
        //쿼리스트링을 swift에서 php 서버로 전송하여 요청
        let url = "http://"+serverUrl+"/pillmeGetData.php"
        var components = URLComponents(string: url)
        //실제 php API에서 Mysql서버로 요청할 쿼리
        var myQuery = URLQueryItem(name: "myQuery", value: query)
        components?.queryItems = [myQuery]
    
        //guard문 --> 해당 url이 존재한다면 그 url을 반환 아니라면 애러문 출력
        guard let url: URL = components?.url else{
            print("invalid URL")
            return self.checkMemberResult
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
            print("검색한 유저 데이터를 성공적으로 다운로드 했습니다!")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
                    
            do{
                self.checkMemberResult = try JSONDecoder().decode( [userModel].self, from: data )
            } catch {
                print(error.localizedDescription)
            }
            
            //while동작을 위한 트리거
            self.run1 = false

        }).resume()
        //로그인 동기처리를 위한 while문
        while run1 {
            
        }
        return self.checkMemberResult
    }
    
    
    //이미 친구인지 확인하는 함수
    func FriendCheck(userID: String, searchID: String) -> [FriendListModel]{
        var query = "SELECT * FROM FriendList WHERE FriendMaster = '"+userID+"' AND FriendID = '"+searchID+"'"
        //쿼리스트링을 swift에서 php 서버로 전송하여 요청
        let url = "http://"+serverUrl+"/pillmeGetData.php"
        var components = URLComponents(string: url)
        //실제 php API에서 Mysql서버로 요청할 쿼리
        var myQuery = URLQueryItem(name: "myQuery", value: query)
        components?.queryItems = [myQuery]
    
        //guard문 --> 해당 url이 존재한다면 그 url을 반환 아니라면 애러문 출력
        guard let url: URL = components?.url else{
            print("invalid URL")
            return self.checkFriendResult
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
            print("확인할 유저 데이터를 성공적으로 다운로드 했습니다!")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
                    
            do{
                self.checkFriendResult = try JSONDecoder().decode( [FriendListModel].self, from: data )
            } catch {
                print(error.localizedDescription)
            }
            
            //while동작을 위한 트리거
            self.run2 = false

        }).resume()
        //로그인 동기처리를 위한 while문
        while run2 {
            
        }
        return self.checkFriendResult
    }
    
    
    //친구를 추가하는 함수
    func addFriend(userID: String, searchID: String){
        var query = "INSERT INTO FriendList (FriendMaster, FriendID) VALUES('"+userID+"', '"+searchID+"')"
        //쿼리스트링을 swift에서 php 서버로 전송하여 요청
        let url = "http://"+serverUrl+"/pillmeApplyData.php"
        var components = URLComponents(string: url)
        //실제 php API에서 Mysql서버로 요청할 쿼리
        var myQuery = URLQueryItem(name: "myQuery", value: query)
        components?.queryItems = [myQuery]
    
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
            
        let responseString = String(data: data, encoding: .utf8)
        print(responseString)
            
        self.run3 = false

        }).resume()
        //동기처리를 위한 while문
        while run3 {
            
        }
    }
}
