//
//  FilterBarView.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import SwiftUI

struct FilterBarView: View {
    
    var filters: [String] = []
    var selected: String?
    var onFilterPressed: ((String) -> Void)?
    var onClosePressed: (() -> Void)?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if !selected.isNull {
                    Image(systemName: "xmark")
                        .padding(8)
                        .background {
                            Circle().stroke(lineWidth: 1)
                        }
                        .foregroundStyle(.white)
                        .background(Color.black.opacity(0.001))
                        .onTapGesture {
                            onClosePressed?()
                        }
                        .transition(AnyTransition.move(edge: .leading))
                        .padding(.leading, 16)
                }
                
                ForEach(filters, id: \.self) { item in
                    if selected.isNull || selected == item {
                        FilterCell(title: item, isSelected: selected == item)
                            .background(Color.black.opacity(0.001))
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    onFilterPressed?(item)
                                }
                            }
                            .padding(.leading, (selected.isNull && item == filters.first) ? 16 : 0)
                    }
                }
                
            }
            .padding(.vertical, 4)
        }
        .scrollIndicators(.hidden)
        .animation(.bouncy, value: selected)
    }
}

fileprivate struct InstaflixFilterBarViewPreview: View {
    
    @State private var items = ["Movies", "TV Shows", "Upcoming", "Trends"]
    @State private var selectedItem: String?
    
    var body: some View {
        FilterBarView(
            filters: items,
            selected: selectedItem,
            onFilterPressed: { item in
                selectedItem = item
            },
            onClosePressed: {
                selectedItem = nil
            }
        )
    }
    
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        InstaflixFilterBarViewPreview()
    }
}
