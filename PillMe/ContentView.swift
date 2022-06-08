//
//  ContentView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/04/16.
//
// to do something
import SwiftUI

public let serverUrl = "34.64.106.196:8080"

struct ContentView: View {
    @State
    var isContentReady : Bool = false
    var body: some View {
            ZStack{
                //LocalNotificationView()
                LoginView()
//                if !isContentReady {
//                    VStack{
//                        LottieView(jsonName: "Loading")
//                        Text("PillMe")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .font(.system(size: 40))
//                        Spacer()
//                    }
//                    .background(Color(red: 102/255, green: 103/255, blue: 171/255).edgesIgnoringSafeArea(.all))
//                    .transition(.opacity)
//
//                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation{
                        isContentReady.toggle()
                    }
                })
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
 }
 
extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
