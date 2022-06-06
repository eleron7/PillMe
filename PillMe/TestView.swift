//
//  TestView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/19.
//

import SwiftUI

struct testView: View{
    
    @State var models : [ResponseModel] = []
    
    var body: some View{
        VStack {
            //now show in list
            //to show in list, model class must be identifiable
            List (self.models) { (model) in
                HStack{
                    Text(model.userID ?? "").bold()
                    Text(model.userPW ?? "")
                    Text(model.userNAME ?? "")
                    Text(model.userTEL ?? "")
                }
            }
        }
        .onAppear(perform: {
                //쿼리스트링을 swift에서 php 서버로 전송하여 요청
                let url = "http://192.168.0.105:80/pillmeGetData.php"
                var components = URLComponents(string: url)
                //실제 php API에서 Mysql서버로 요청할 쿼리
                let myQuery = URLQueryItem(name: "myQuery", value: "SELECT * FROM member WHERE userid = 'Eleron' AND userPW = '1234'")
                components?.queryItems = [myQuery]
            
                //guard문 --> 해당 url이 존재한다면 그 url을 반환 아니라면 애러문 출력
                guard let url: URL = components?.url else{
                    print("invalid URL")
                    return
                }
                
                //위에서 확인한 url로 GET 방식으로 요청
                var urlRequst: URLRequest = URLRequest(url: url)
                urlRequst.httpMethod = "GET"
                URLSession.shared.dataTask(with: urlRequst, completionHandler: {
                    (data, response, error) in
                    //check if response is okay
                    guard let data = data else {
                        print("invalid response")
                        return
                    }
                    
                    
                    //convert JSON response into class model as an array
                    do {
                        self.models = try
                            JSONDecoder().decode(
                                [ResponseModel].self, from: data
                            )
                    } catch {
                        print(error.localizedDescription)
                    }
                }).resume()
            })
    }
}

//create model class
class ResponseModel: Codable, Identifiable{
    var userID: String? = ""
    var userPW: String? = ""
    var userNAME: String? = ""
    var userTEL: String? = ""
}

struct testView_Previews: PreviewProvider{
    static var previews: some View{
        testView()
    }
}
