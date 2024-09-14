//
//  InstaflixItemCell.swift
//  Instaflix
//
//  Created by Kleiber Perez on 10/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MediaItemCell: View {
    
    private let urlImg: URL?
    private let imgSize: CGSize
    private let itemTitle: String
    
    init(url: String,
         title: String = "",
         with size: CGSize = CGSize(width: 480, height: 720)) {
        self.urlImg = URL(string: url)
        self.imgSize = size
        self.itemTitle = title
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            imageItem()
            if !itemTitle.isEmpty {
                VStack {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.black.opacity(0.1),.clear,.black.opacity(0.1),.black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                        Text(itemTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(width: imgSize.width/2.8, height: imgSize.height/3.5)
        .background(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func imageItem() -> some View {
        WebImage(url: urlImg) { image in
                image.image?.resizable()
            }
            .scaledToFill()
    }
}

#Preview {
    MediaItemCell(url: "https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg")
}
