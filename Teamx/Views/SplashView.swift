//
//  SplashView.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-11-08.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var animateTransition = false
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 0
    @State private var pencilOpacity: Double = 0

    let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            if isActive {
                ContentView()
                    .scaleEffect(animateTransition ? 1 : 0.1)
                    .rotationEffect(.degrees(animateTransition ? 0 : 360))
                    .opacity(animateTransition ? 1 : 0)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5)) {
                            animateTransition = true
                        }
                    }
            } else {
                VStack {
                    Text("TeamX")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                scale = 1.5
                            }
                            withAnimation(.easeIn(duration: 2)) {
                                opacity = 1
                            }
                        }
                }
                LineCircleAnimationView()
                    .opacity(pencilOpacity)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).delay(3)) {
                            pencilOpacity = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                
                LiquidAnimationView()
                    .opacity(pencilOpacity)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).delay(3)) {
                            pencilOpacity = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(gradient)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CircularAnimationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(360), anchor: .center) // Rotate 360 degrees
            .animation(
                Animation.linear(duration: 2)
                    .repeatForever(autoreverses: false)
            )
    }
}

struct LineCircleAnimationView: View {
    @State private var bounce = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full Vertical Line with Bouncing Circle
                BouncingLineWithCircle(lineWidth: geometry.size.height, color: Color.purple, bounceAmount: $bounce)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .rotationEffect(.degrees(90))

                // Horizontal Line with Bouncing Circle
                BouncingLineWithCircle(lineWidth: geometry.size.width, color: Color.blue, bounceAmount: $bounce)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 4)

                // Diagonal Line with Bouncing Circle
                BouncingLineWithCircle(lineWidth: sqrt(pow(geometry.size.width, 2) + pow(geometry.size.height, 2)), color: Color.green, bounceAmount: $bounce)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .rotationEffect(.degrees(45))
            }
            .opacity(0.8)  // Adjusted opacity for subtlety
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    bounce.toggle()
                }
            }
        }
    }
}

struct BouncingLineWithCircle: View {
    var lineWidth: CGFloat
    var color: Color
    @Binding var bounceAmount: Bool

    var body: some View {
        ZStack {
            Line()
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: lineWidth, height: 3)

            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(color)
                .opacity(0.7)
                .offset(x: bounceAmount ? lineWidth / 2 : -lineWidth / 2)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true)
                )
        }
    }
}

struct LineWithCircle: View {
    var lineWidth: CGFloat
    var color: Color

    var body: some View {
        ZStack {
            Line()
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: lineWidth, height: 3)

            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(color)
                .opacity(0.7)
                .offset(x: lineWidth / 2)
            
            
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}

struct LiquidAnimationView: View {
    @State private var animate = false

    let colors: [Color] = [Color.blue.opacity(0.6), Color.purple.opacity(0.6), Color.blue.opacity(0.3)]
    let durations: [Double] = [1.0, 0.7, 1.3] // Different durations for variation
    let delays: [Double] = [0, 0.2, 0.4] // Start at different times

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<colors.count, id: \.self) { index in
                    Circle()
                        .fill(colors[index])
                        .frame(width: 40, height: 40)
                        .scaleEffect(animate ? 5 : 1)
                        .opacity(animate ? 0 : 1)
                        .animation(
                            Animation.easeOut(duration: durations[index])
                                .repeatForever(autoreverses: false)
                                .delay(delays[index])
                        )
                }
            }
            .onAppear {
                self.animate = true
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

//struct ShimmerView: View {
//    @State private var isAnimating = false
//
//    var body: some View {
//        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.75), Color.clear]), startPoint: .leading, endPoint: .trailing)
//            .frame(width: 200, height: 100)
//            .mask(Text("TeamX").font(.largeTitle).fontWeight(.bold))
//            .offset(x: isAnimating ? 200 : -200)
//            .onAppear {
//                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
//                    isAnimating = true
//                }
//            }
//    }
//}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

