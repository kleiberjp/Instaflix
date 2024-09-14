//
//  AppRouting.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import SwiftUI

struct AppRouting<Destination: DestinationProtocol>: ViewModifier {
    
    @Binding var destination: Destination?
    @State var isLinkActive = false
    @State var isURLActive = false
    @State var isBottomSheetActive = false
    
    func body(content: Content) -> some View {
      ZStack {
          NavigationLink(isActive: $isLinkActive) {
              destinationView
          } label: { }
          content
      }.sheet(isPresented: $isURLActive, content: { destinationView })
       .sheet(isPresented: $isBottomSheetActive, content: { destinationView })
       .onChange(of: destination, perform: {_ in routeChanged()})
       .onChange(of: isLinkActive, perform: {_ in routeDismissed()})
       .onChange(of: isURLActive, perform: {_ in routeDismissed()})
       .onChange(of: isBottomSheetActive, perform: {_ in routeDismissed()})
    }

    var destinationView: some View {
      destination?.content
    }

    func routeDismissed() {
      if !isLinkActive && !isURLActive && !isBottomSheetActive {
        destination = nil
      }
    }

    func routeChanged() {
      guard let destination = destination else { return }
      isLinkActive = destination.transition == .push
      isBottomSheetActive = destination.transition == .bottomSheet
      isURLActive = destination.transition == .url
    }
  }

  struct Navigator: ViewModifier {
    func body(content: Content) -> some View {
      NavigationView {
        content
      }
       .navigationBarColor(backgroundColor: .clear, titleColor: .white)
      .accentColor(.white)
    }
  }

  extension View {
    func route<Destination: DestinationProtocol>(to destination: Binding<Destination?>) -> some View {
      modifier(AppRouting(destination: destination))
    }

    func navigation() -> some View {
      modifier(Navigator())
    }
  }
