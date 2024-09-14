//
//  MainCoordinator.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import SwiftUI
import Combine

struct MainCoordinator: CoordinatorProtocol {

    @StateObject var viewModel: MainViewModel

    @State var activeRoute: Destination? = Destination(route: .detail(item: nil))
    @State var transition: TransitionView?

    @State private var isLoaded: Bool = Bool()

    let subscriber = CancelBag()

    var body: some View {
        mainView
            .route(to: $activeRoute)
            .navigation()
            .onAppear {
                self.mainView.viewModel.navigateSubject
                    .sink { route in
                        activeRoute = Destination(route: route)
                    }.store(in: subscriber)
            }
    }

    var mainView: MainView {
        MainView(viewModel: viewModel)
    }
}

extension MainCoordinator {
    struct Destination: DestinationProtocol {
        
        var route: MainView.MainViewRoutes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .detail(let media):
                DetailView(media: media)
            }
        }
            
        var transition: TransitionView {
            switch route {
            case .detail:
                return .push
            }
        }
    }
}
