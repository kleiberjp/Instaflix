//
//  ViewLyfeCicleModifier.swift
//  Instaflix
//
//  Created by Kleiber Perez on 13/09/24.
//

import SwiftUI

struct ViewLyfeCicleModifier: ViewModifier {
        
    @State private var viewDidload = false
    let action: (() -> Void)?

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidload == false {
                    viewDidload = true
                    action?()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewLyfeCicleModifier(action: action))
    }
}


