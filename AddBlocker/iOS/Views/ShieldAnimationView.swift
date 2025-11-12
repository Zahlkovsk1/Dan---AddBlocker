//
//  ShieldAnimationView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI

struct ShieldAnimationView: View {
    @Namespace private var shieldNS
    @State private var start = Date()
    @State private var showShield = false
    @State private var particlesActive = false
    
    var body: some View {
        TimelineView(.animation) { tl in
            let t = start.distance(to: tl.date)
            
            let pulsePhase = t * Double.pi * 0.5
            let pulseIntensity = 0.7 + sin(pulsePhase) * 0.3
            
            let scanRotation = t * 30
            
            let particlePhase = t * Double.pi * 0.3
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.08),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 30,
                            endRadius: 200
                        )
                    )
                    .blur(radius: 20)
                    .frame(width: 300, height: 300)
                    .opacity(pulseIntensity)
                    .scaleEffect(pulseIntensity)
                
                Group {
                    if showShield {
                        ZStack {
                            ShieldShape()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.8),
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 80, height: 95)
                                .shadow(color: .white.opacity(0.3), radius: 5)
                                .matchedGeometryEffect(id: "shield-outline", in: shieldNS)
                            
                            // Inner shield glow
                            ShieldShape()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.15),
                                            Color.white.opacity(0.05),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 50
                                    )
                                )
                                .frame(width: 75, height: 90)
                                .matchedGeometryEffect(id: "shield-fill", in: shieldNS)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 35, weight: .bold))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .white.opacity(0.5), radius: 3)
                                .matchedGeometryEffect(id: "checkmark", in: shieldNS)
                            
                            ForEach(0..<3, id: \.self) { i in
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.clear,
                                                Color.white.opacity(0.3),
                                                Color.clear
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 100, height: 1.5)
                                    .offset(y: CGFloat(i) * 30 - 30)
                                    .opacity(0.6)
                                    .rotationEffect(.degrees(scanRotation + Double(i) * 120))
                                    .matchedGeometryEffect(id: "scan-\(i)", in: shieldNS)
                            }
                        }
                        
                        if particlesActive {
                            ForEach(0..<8, id: \.self) { index in
                                let angle = particlePhase + Double(index) * (Double.pi * 2 / 8)
                                let radius: CGFloat = 65
                                let x = cos(angle) * radius
                                let y = sin(angle) * radius
                                let scale = 0.6 + sin(particlePhase + Double(index)) * 0.4
                                
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.8),
                                                Color.white.opacity(0.2)
                                            ]),
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 5
                                        )
                                    )
                                    .frame(width: 6, height: 6)
                                    .scaleEffect(scale)
                                    .shadow(color: .white.opacity(0.4), radius: 2)
                                    .offset(x: x, y: y)
                                    .opacity(0.7)
                                    .matchedGeometryEffect(id: "particle-\(index)", in: shieldNS)
                            }
                        }
                        
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.1),
                                        Color.white.opacity(0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 110, height: 110)
                            .opacity(pulseIntensity * 0.8)
                            .scaleEffect(pulseIntensity)
                            .matchedGeometryEffect(id: "ring", in: shieldNS)
                        
                    } else {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .matchedGeometryEffect(id: "shield-outline", in: shieldNS, isSource: true)
                        
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                            .matchedGeometryEffect(id: "shield-fill", in: shieldNS, isSource: true)
                        
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 4, height: 4)
                            .matchedGeometryEffect(id: "checkmark", in: shieldNS, isSource: true)
                        
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 2, height: 2)
                                .matchedGeometryEffect(id: "scan-\(i)", in: shieldNS, isSource: true)
                        }
                        
                        ForEach(0..<8, id: \.self) { index in
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 2, height: 2)
                                .matchedGeometryEffect(id: "particle-\(index)", in: shieldNS, isSource: true)
                        }
                        
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            .frame(width: 10, height: 10)
                            .matchedGeometryEffect(id: "ring", in: shieldNS, isSource: true)
                    }
                }
                .compositingGroup()
            }
            .frame(width: 140, height: 140)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                    showShield = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        particlesActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Shield Shape
struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
    
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control1: CGPoint(x: width * 0.75, y: height * 0.05),
            control2: CGPoint(x: width, y: height * 0.15)
        )
        
        path.addLine(to: CGPoint(x: width, y: height * 0.65))
        
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control1: CGPoint(x: width, y: height * 0.8),
            control2: CGPoint(x: width * 0.7, y: height * 0.95)
        )
        
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.65),
            control1: CGPoint(x: width * 0.3, y: height * 0.95),
            control2: CGPoint(x: 0, y: height * 0.8)
        )
        
        path.addLine(to: CGPoint(x: 0, y: height * 0.3))
        
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control1: CGPoint(x: 0, y: height * 0.15),
            control2: CGPoint(x: width * 0.25, y: height * 0.05)
        )
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color.black
        ShieldAnimationView()
    }
}

