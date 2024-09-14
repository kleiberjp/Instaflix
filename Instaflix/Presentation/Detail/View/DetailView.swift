//
//  DetailView.swift
//  Instaflix
//
//  Created by Kleiber Perez on 13/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    
    private let media: MediaItem?
    private let urlImg: URL?
    
    init(media: MediaItem?) {
        self.media = media
        self.urlImg = URL(string: media?.posterURL ?? "")
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GeometryReader { _ in
                ScrollView {
                    VStack(spacing: 16) {
                        heroView
                        detailMediaView
                    }
                    .padding(.horizontal,20)
                    .padding(.vertical,20)
                }
                .scrollIndicators(.hidden)
            }
        }
        .toolbarColorScheme(.light, for: .tabBar)
        .ignoresSafeArea(edges: .bottom)
        .onDisappear{UIScrollView.appearance().bounces = true}
        
    }
    
    
    @ViewBuilder private var heroView: some View {
        ZStack(alignment: .bottom) {
            WebImage(url: urlImg) { image in
                    image.image?.resizable()
                }
                .scaledToFill()
            
            VStack {
                ZStack(alignment: .bottom) {
                    LinearGradient(colors: [.black.opacity(0.1),.clear,.black.opacity(0.1),.black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    Text(media?.title ?? "")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .padding(.horizontal,20)
                        .padding(.bottom)
                }
                .padding(.bottom)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .background(RoundedRectangle(cornerRadius: 10))
        
    }
    
    @ViewBuilder private var detailMediaView: some View {
        Group {
            if let desc = media?.overview {
                Text(desc)
            }
        }
        .font(.headline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        DetailView(media: MediaItem(id: 0, overview: "Esto es una puta descripcion", posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", mediaType: .movie))

    }
}
