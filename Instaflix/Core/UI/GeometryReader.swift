//
//  GeometryReader.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import SwiftUI

struct GeometryFrameReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ frame: CGRect) -> Void
    
    init(coordinateSpace: CoordinateSpace, onChange: @escaping (_ frame: CGRect) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.onChange = onChange
    }

    var body: some View {
        GeometryReader { geo in
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear(perform: {
                    onChange(geo.frame(in: coordinateSpace))
                })
                .onChange(of: geo.frame(in: coordinateSpace), perform: onChange)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension View {
    /// Get the frame of the View
    ///
    /// Adds a GeometryReader to the background of a View.
    func readingFrame(coordinateSpace: CoordinateSpace = .global, onChange: @escaping (_ frame: CGRect) -> ()) -> some View {
        background(GeometryFrameReader(coordinateSpace: coordinateSpace, onChange: onChange))
    }
}

fileprivate struct GemoetryFrameReaderViewPreview: View {
    
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("")
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .background(Color.green)
                    .padding()
                    .readingFrame { frame in
                        yOffset = frame.minY
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
    GemoetryFrameReaderViewPreview()
}
