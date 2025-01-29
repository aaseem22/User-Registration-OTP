//
//  ConfettiView.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 29/01/25.
//

import SwiftUI

struct ConfettiContainerView: View {
    var count: Int = 50
    @State var yPosition: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { _ in
                ConfettiView()
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: yPosition != 0 ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : yPosition
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            yPosition = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct ConfettiView: View {
    @State var animate = false
    @State var xSpeed = Double.random(in: 0.7...2)
    @State var zSpeed = Double.random(in: 1...2)
    @State var anchor = CGFloat.random(in: 0...1).rounded()
    
    var body: some View {
        Rectangle()
            .fill([Color.orange, Color.green, Color.blue, Color.red, Color.yellow].randomElement() ?? Color.green)
            .frame(width: 15, height: 15)
            .onAppear(perform: { animate = true })
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 1))
            .animation(Animation.linear(duration: xSpeed).repeatForever(autoreverses: false), value: animate)
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 0, y: 0, z: 1), anchor: UnitPoint(x: anchor, y: anchor))
            .animation(Animation.linear(duration: zSpeed).repeatForever(autoreverses: false), value: animate)
    }
}

#Preview {
    ConfettiContainerView()
}
