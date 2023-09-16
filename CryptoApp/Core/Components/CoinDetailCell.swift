//
//  CoinDetailCell.swift
//  CryptoApp
//
//  Created by apple on 26/07/23.
//

import SwiftUI

struct CoinDetailCell: View {
    let coin: CoinModel
    
    var body: some View {
        VStack{
            ImageView(url: coin.image)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(0.5)
                .bold()
            Text(coin.name)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailCell(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
