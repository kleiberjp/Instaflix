//
//  ErrorRequestView.swift
//  Instaflix
//
//  Created by Kleiber Perez on 13/09/24.
//

import SwiftUI

struct ErrorRequestView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Oh no 😥, something went wrong ")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .padding(.bottom, 40).padding()
            Button(action: retryAction, label: {
                Text("Retry").bold()
            })
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    ErrorRequestView(error: NetworkError.serverError, retryAction: {})
}
