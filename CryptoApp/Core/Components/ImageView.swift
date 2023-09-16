//
//  CircularImageView.swift
//  CryptoApp
//
//  Created by apple on 23/07/23.
//

import SwiftUI

struct ImageView: View {
    let url: String
    
    var body: some View {
        if let url = URL(string: url) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    Image("error")
                        .resizable()
                        .scaledToFit()
                case .empty:
                    ProgressView()
                        .foregroundColor(.theme.accentColor)
                @unknown default:
                    Image("error")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        else {
            Image("error")
                .resizable()
                .scaledToFit()
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: dev.coin.image)
            .previewLayout(.sizeThatFits)
    }
}
