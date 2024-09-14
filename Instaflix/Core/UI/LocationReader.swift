//
//  LocationReader.swift
//  Instaflix
//
//  Created by Kleiber Perez on 13/09/24.
//

import SwiftUI

/// Adds a transparent View and read it's center point.
/// Adds a GeometryReader with 0px by 0px frame.
struct LocationReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ location: CGPoint) -> Void

    init(coordinateSpace: CoordinateSpace, onChange: @escaping (_ location: CGPoint) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.onChange = onChange
    }
    
    var body: some View {
        GeometryFrameReader(coordinateSpace: coordinateSpace) { frame in
            onChange(CGPoint(x: frame.midX, y: frame.midY))
        }
        .frame(width: 0, height: 0, alignment: .center)
    }
}

extension View {
    /// Get the center point of the View
    /// Adds a 0px GeometryReader to the background of a View.
    func readingLocation(coordinateSpace: CoordinateSpace = .global, onChange: @escaping (_ location: CGPoint) -> ()) -> some View {
        background(LocationReader(coordinateSpace: coordinateSpace, onChange: onChange))
    }
}

fileprivate struct LocationReaderPreview: View {
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Hello, world!")
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .background(Color.green)
                    .padding()
                    .readingLocation { location in
                        yOffset = location.y
                    }
                
                ForEach(0..<30) { x in
                    Text("")
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .background(Color.green)
                        .padding()
                }
            }
        }
        .coordinateSpace(name: "test")
        .overlay(Text("Offset: \(yOffset)"))
    }
}

#Preview {
    LocationReaderPreview()
}
