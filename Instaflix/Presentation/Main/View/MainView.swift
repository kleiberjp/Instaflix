//
//  MainView.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import SwiftUI
import Combine

struct MainView: Coordinatable {
    typealias Route = MainViewRoutes
    
    @ObservedObject var viewModel: MainViewModel
    
    @State private var offsetScreen: CGFloat = 0
    @State private var headerSize: CGSize = .zero
    @State private var screenSize: CGSize = .zero
    
    var body: some View {
        content
    }
    
    private var columnsFiltered: [GridItem] {
        [GridItem(.adaptive(minimum: screenSize.width/2.8), spacing: 8)]
    }
    
    @ViewBuilder private var content: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()
                GeometryReader { _ in
                    backgroundGradientLayer
                    
                    contentManaged
                    
                    headerBarView
                }
                .readingFrame { frame in
                    self.screenSize = frame.size
                }
                
            }
            .foregroundStyle(.white)
            .ignoresSafeArea(edges: .bottom)
        }
        
    }
    
    @ViewBuilder private var contentManaged: some View {
        switch viewModel.mediaItems {
        case let .failed(error):
            failedView(with: error)
        case .loaded(_):
            loadedDataLayer
        default:
            AnyView(Text("Cargo esta vaina").foregroundStyle(Color.black))
        }
    }
    
    @ViewBuilder private func failedView(with error: Error) -> some View {
        ErrorRequestView(error: error) {
            self.viewModel.callFirsTime()
        }
    }
    
    // MARK: List View Components
    
    @ViewBuilder private var loadedDataLayer: some View {
        ScrollViewChangeDetector {
            VStack(spacing: 8) {
                Rectangle()
                    .opacity(0)
                    .frame(height: headerSize.height)
                
                contentMediaSections
            }
            .padding(.bottom, 30)
        } onScrollChanged: { offset in
            offsetScreen = min(0, offset.y)
        }
    }
    
    @ViewBuilder private var contentMediaSections: some View {
        if !viewModel.selectedCategory.isNull {
            gridFilteredContent
        } else {
            mainMediaSectionsContent
        }
    }
    
    @ViewBuilder private var mainMediaSectionsContent: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(viewModel.sections.enumerated()), id: \.offset) {(_,section) in
                VStack(alignment: .leading, spacing: 16) {
                    Text(section.type.headline)
                        .foregroundStyle(Color.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .shimmer(when: $viewModel.isloading)
                        .padding(.horizontal,16)
                    mediaListContent(for: section.items)
                }
            }
        }.padding(.top, 20)
    }
    
    @ViewBuilder private func mediaListContent(for items: [MediaItem]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                mediaItems(items)
            }
            .padding(.horizontal, 16)

        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder private var gridFilteredContent: some View {
        LazyVGrid(columns: columnsFiltered) {
            mediaItems(viewModel.filteredMediaItems)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder private func mediaItems(_ items: [MediaItem]) -> some View{
        ForEach(Array(items.enumerated()), id: \.offset) { (_, media) in
            MediaItemCell(url: media.posterURL,
                          with: screenSize)
                .shimmer(when: $viewModel.isloading)
                .padding(5)
                .onTapGesture {
                    self.viewModel.seeDetail(media)
                }
        }
    }
    
    // MARK: Header Elements
    
    @ViewBuilder private var backgroundGradientLayer: some View {
        ZStack {
            LinearGradient(colors: [.instaflixGray.opacity(1), .instaflixGray.opacity(0)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            LinearGradient(colors: [.instaflixRed.opacity(0.5), .instaflixRed.opacity(0)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .frame(maxHeight: max(10, (400 + (offsetScreen * 0.75))))
        .opacity(offsetScreen < -250 ? 0 : 1)
        .animation(.easeInOut, value: offsetScreen)
    }
    
    
    @ViewBuilder private var headerBarView: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
            
            if offsetScreen > -20 {
                FilterBarView(
                    filters: viewModel.categories.map { $0.rawValue },
                    selected: viewModel.selectedCategory?.rawValue,
                    onFilterPressed: {
                        viewModel.filterMediaItems(by: $0)
                    },
                    onClosePressed: {
                        viewModel.filterMediaItems(by: nil)
                    })
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.bottom, 8)
        .background(
            ZStack {
                if offsetScreen < -70 {
                    Rectangle()
                        .fill(.clear)
                        .background(.ultraThinMaterial)
                        .brightness(-0.2)
                        .ignoresSafeArea()
                }
            }
        )
        .animation(.smooth, value: offsetScreen)
        .readingFrame { frame in
            if headerSize == .zero {
                headerSize = frame.size
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("Instaflix")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
        }
    }
    
}

extension MainView {
    enum MainViewRoutes: Routing {
        case detail(item: MediaItem?)
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
