//
//  Routing.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import SwiftUI

enum TransitionView {
  case push
  case bottomSheet
  case url
}

// implemented by routes enum inside each view
protocol Routing: Equatable {}

// implemented by the view that has routes
protocol Coordinatable: View {
  associatedtype Route: Routing
}

protocol DestinationProtocol: Equatable {
  associatedtype Destination: View
  var content: Destination { get }
  var transition: TransitionView { get }
}

protocol CoordinatorProtocol: View {
  associatedtype MainContent: Coordinatable
  associatedtype Destination: DestinationProtocol
  var mainView: MainContent { get }
  var activeRoute: Destination? { get }
}

protocol LifeCycleViewDataFlow {
    associatedtype InputType
    func apply(_ input: InputType)
}
