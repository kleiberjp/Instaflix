//
//  FilterCell.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import SwiftUI

struct FilterCell: View {
    
    @Namespace private var animatedCell
    
    var title: String = "Categories"
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(isSelected ? .black
                             : .white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            ZStack {
                if isSelected {
                    Capsule(style: .circular)
                        .fill(.white)
                        .matchedGeometryEffect(id: "ACTIVECELL", in: animatedCell)
                        
                } else {
                    Capsule(style: .circular)
                        .stroke(.white, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            FilterCell()
            FilterCell(isSelected: true)
        }
    }
}
