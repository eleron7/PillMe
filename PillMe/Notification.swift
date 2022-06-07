//import SwiftUI
//import UserNotifications
//
//class NotificationManager{
//    static let instance = NotificationManager()
//
//    //알림권한요청
//    func requestAuthorization()
//    {
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
//            if let error = error{ print("ERROR: \(error)") }
//            else{ print("SUCCESS") }
//        }
//    }
//
//    //푸시 알림 생성
//    func scheduleNotifiation(selectHour : Int, selectMinute : Int){
//        let content = UNMutableNotificationContent()
//        
//        content.title = "PillMe"
//        content.subtitle = "Eat Pill!"//약먹을시간과 약 이름
//        
//        content.sound = .default
//        content.badge = 1
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: selectHour, minute: selectMinute), repeats: false)
//        let request = UNNotificationRequest(
//            identifier: UUID().uuidString,//알림의 식별자를 통해 이것을 취소할 수 있음
//            content: content,
//            trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//        
//        print("add Notification : "+String(selectHour)+":"+String(selectMinute));
//    }
//}
//
//struct LocalNotificationView: View{
//    @State var hour: String = ""
//    @State var minute: String = ""
//    @State var identifier: String = ""
//    var body :some View{
//        VStack(spacing: 40)
//        {
//            Button("Request permission")
//            {
//                NotificationManager.instance.requestAuthorization()
//            }
//            
//            TextField("hour", text: $hour)
//                .padding()
//            
//            TextField("minute", text: $minute)
//                .padding()
//            
//            Button("registration notification")
//            {
//                NotificationManager.instance.scheduleNotifiation(selectHour : Int(self.hour)!, selectMinute : Int(self.minute)!)
//            }
//            
//            TextField("minute", text: $identifier)
//                .padding()
//            
////            Button("cancel notification")
////            {
////                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: "123")
////            }
//        }
//        .onAppear(perform: {
//            UIApplication.shared.applicationIconBadgeNumber = 0
//
//        })
//    }
//}
//
//
//struct LocalNotificationView_Previews : PreviewProvider{
//    static var previews: some View{
//        LocalNotificationView()
//    }
//}
//
