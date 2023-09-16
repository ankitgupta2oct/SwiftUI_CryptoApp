//
//  CoinRowItem.swift
//  CryptoApp
//
//  Created by apple on 20/07/23.
//

import SwiftUI

struct CoinRowItem: View {
    let coinModel: CoinModel
    let showHoldings: Bool
    
    var body: some View {
        HStack {
            leftcolumn
            Spacer()
            if showHoldings {
                centerColumn
            }
            rightcolumn
        }
        .foregroundColor(.theme.accentColor)
        .font(.subheadline)
    }
}

extension CoinRowItem {
    private var leftcolumn: some View {
        HStack {
            Text("\(coinModel.rank)")
                .foregroundColor(.theme.secondaryTextColor)
                .frame(width: 20)
            ImageView(url: coinModel.image)
                .clipShape(Circle())
                .frame(minWidth: 30, idealWidth: 30, maxWidth: 40, minHeight: 30, idealHeight: 30, maxHeight: 40)
                .overlay(Circle().stroke(lineWidth: 2))
                .shadow(color: .theme.accentColor.opacity(0.5), radius: 5)
            Text(coinModel.symbol.uppercased())
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coinModel.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text("\((coinModel.currentHoldings ?? 0).asNumberString())")
                .foregroundColor(.theme.secondaryTextColor)
        }
    }
    
    private var rightcolumn: some View {
        VStack(alignment: .trailing) {
            Text(coinModel.currentPrice.asCurrencyWith2Decimals())
                .bold()
            Text("\((coinModel.priceChangePercentage24H ?? 0.0).asPercentageString())")
                .foregroundColor(coinModel.priceChangePercentage24H ?? 0 > 0 ? .theme.greenColor : .theme.redColor)
        }
        .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

struct CoinRowItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowItem(coinModel: dev.coin, showHoldings: true)
                .preferredColorScheme(.dark)
            
            CoinRowItem(coinModel: dev.coin, showHoldings: false)
        }
        .previewLayout(.sizeThatFits)
    }
}
