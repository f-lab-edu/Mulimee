//
//  LottieView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    var lottieFile: String = "bubble"
    var loopMode: LottieLoopMode = .playOnce
    var animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        self.animationView.animation = LottieAnimation.named(lottieFile)
        self.animationView.contentMode = .scaleAspectFill
        self.animationView.loopMode = loopMode
        
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.animationView)
        
        NSLayoutConstraint.activate([
            self.animationView.topAnchor.constraint(equalTo: view.topAnchor),
            self.animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        self.animationView.play()
    }
}

#Preview {
    LottieView(lottieFile: "bubble")
}
