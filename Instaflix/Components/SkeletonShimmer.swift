//
//  SkeletonShimmer.swift
//  Instaflix
//
//  Created by Kleiber Perez on 10/09/24.
//

import SwiftUI

public enum ShimmerAnimation {
    case bouncy
    case linear
    
    var animation: Animation {
        switch self {
        case .bouncy:
            return .bouncy(duration: 1.5).delay(0.25).repeatForever(autoreverses: false)
        default:
            return .linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false)
        }
    }
}

public struct SkeletonShimmer: ViewModifier {
    private let animation: Animation
    ///  Min and Max size of the animated mask's "band"
    private let min, max: CGFloat
    @State private var isInitialState = true
    
    private let gradient: Gradient =  Gradient(colors: [
        .black.opacity(0.4), // translucent
        .black, // opaque
        .black.opacity(0.3) // translucent
    ])
    
    private var startPoint: UnitPoint {
        return isInitialState ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1)
    }
    
    private var endPoint: UnitPoint {
        return isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max)
    }
     
    private var maskGradient: LinearGradient {
         return LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }
    
    public init(
        animationType: ShimmerAnimation = .bouncy,
        bandSize: CGFloat = 0.3) {
        
            self.animation = animationType.animation
            self.min = 0 - bandSize
            self.max = 1 + bandSize
    }
    
    public func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .mask(maskGradient)
            .animation(animation, value: isInitialState)
            .onAppear {
                isInitialState = false
            }
    }
}


extension View {
    @ViewBuilder
    func shimmer(when isLoading: Binding<Bool>) -> some View {
        if isLoading.wrappedValue {
            modifier(SkeletonShimmer())
                .redacted(reason: isLoading.wrappedValue ? .placeholder : [])
        } else {
            self
        }
    }
}
