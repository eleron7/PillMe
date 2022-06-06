//
//  LottieView.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/04/16.
//

import Lottie
import SwiftUI
import UIKit

struct LottieView: UIViewRepresentable {
    
    var name : String
    var loopMode : LottieLoopMode

    init(jsonName: String = "Loading", _ loopMood : LottieLoopMode = .loop){
        print("LottieView - init() called / jsonName:", jsonName)
        self.name = jsonName
        self.loopMode = loopMood
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        print("LottieView - makeUIView() called")
        let view = UIView(frame: .zero)

        let animationView = AnimationView()
        let animation = Animation.named(name)
        
        animationView.animation = animation
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = loopMode
        
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("LottieView - updateUIView() called")
    }
}
