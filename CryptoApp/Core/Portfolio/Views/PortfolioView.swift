//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by apple on 26/07/23.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State var selectedCoin: CoinModel?
    @State var quantityString: String = ""
        
    var body: some View {
        NavigationStack {
            VStack {
                SearchbarView(searchText: $homeViewModel.searchText)
                
                coinCellView

                if let selectedCoin = selectedCoin {
                    getcoinDetailView(selectedCoin: selectedCoin)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Edit Portfolio")
            .background(Color.theme.backgroundColor.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButtonView()
                }
                
                if let selectedCoin = selectedCoin {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        getSaveToolbarView(selectedCoin: selectedCoin)
                    }
                }
            }
            .onChange(of: homeViewModel.searchText) { newValue in
                if(homeViewModel.searchText.isEmpty) {
                    unselectCoin()
                }
            }
        }
    }
    
    private func SaveClicked() {
        guard let selectedCoin = selectedCoin,
              let amount = Double(quantityString)
        else {
            return
        }
        
        unselectCoin()
        homeViewModel.portfolioDataService.updatePortfolio(coinModel: selectedCoin, amount: amount)
    }
    
    private func getSaveToolbarView(selectedCoin: CoinModel) -> some View {
        return HStack(spacing: 3) {
            Image(systemName: "checkmark")
            Text("Save")
        }
        .onTapGesture(perform: SaveClicked)
        .font(.title)
        .opacity(isHoldingModified(holing: selectedCoin.currentHoldings) ? 1 : 0)
        .foregroundColor(Color.theme.accentColor)
    }
    
    private func unselectCoin() {
        quantityString = ""
        selectedCoin = nil
        UIApplication.shared.endEditiing()
    }
    
    private func isHoldingModified(holing: Double?) -> Bool {
        guard let quantity = Double(quantityString) else {
            return false
        }
        
        guard let holding = holing else {
            return true
        }
        
        return holding != quantity
    }
    
    private func getCurrentValue(quantityString: String, price: Double) -> Double {
        guard let quantity = Double(quantityString) else {
            return 0
        }
        
        return quantity * price
    }
    
    private func getcoinDetailView(selectedCoin: CoinModel) -> some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin.symbol): ")
                Spacer()
                Text(selectedCoin.currentPrice.asCurrencyWith2Decimals())
            }
            Divider()
            HStack {
                Text("Quantity: ")
                Spacer()
                TextField("Ex: 1.4, 2 etc.", text: $quantityString)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue(quantityString: quantityString, price: selectedCoin.currentPrice).asCurrencyWith2Decimals())
            }
        }
        .bold()
        .padding(.horizontal)
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let holdingModel = homeViewModel.portfolioCoinData.first(where: {$0.id == coin.id}),
           let amount = holdingModel.currentHoldings {
            quantityString = "\(amount)"
        } else {
            quantityString = ""
        }
    }
}

extension PortfolioView {
    var coinCellView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                ForEach(homeViewModel.searchText.isEmpty ? homeViewModel.portfolioCoinData : homeViewModel.allCoins) { coin in
                    CoinDetailCell(coin: coin)
                        .frame(width: 70)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(selectedCoin?.id == coin.id ? .theme.greenColor : .clear)
                        }
                        .onTapGesture {
                            updateSelectedCoin(coin: coin)
                        }
                }
            }
            .frame(height: 120)
            .padding()
        }

    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeViewModel)
            .preferredColorScheme(.dark)
    }
}
