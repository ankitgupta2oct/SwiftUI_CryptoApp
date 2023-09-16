//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by apple on 05/08/23.
//

import SwiftUI

struct CoinDetailView: View {
    @StateObject var vm: CoinDetailViewModel
    @State var showFullDescription: Bool = false
    
    private let coin: CoinModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("CoinDetailView called with \(coin.name)")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                
                ChartView(coin: coin)
                    .frame(width: .infinity, height: 200)
                
                overView
                
                additionalView
                
                linksView
            }
            .padding(.horizontal)
        }
        .background(Color.theme.backgroundColor.ignoresSafeArea())
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(coin.symbol.uppercased())
                        .foregroundColor(.theme.secondaryTextColor)
                    ImageView(url: coin.image)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .navigationTitle(coin.name)
    }
}

extension CoinDetailView {
    private var overView: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let description = vm.description {
                getDescriptionView(description: description)
            }
            
            Divider()
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: 30) {
                ForEach(vm.overViewItems) { stat in
                    StatisticsView(statisticsModel: stat)
                }
            }
        }
    }
    
    private func getDescriptionView(description: String) -> some View {
        VStack(alignment: .leading) {
            Text(description)
                .lineLimit(showFullDescription ? nil : 3)
                .foregroundColor(.theme.secondaryTextColor)
                .font(.caption)
            Button {
                withAnimation(.easeInOut) {
                    showFullDescription.toggle()
                }
            } label: {
                Text(showFullDescription ? "Less" : "Read more...")
                    .font(.caption)
                    .bold()
                    .tint(.blue)
                    .padding(.top, 2)
            }
        }
    }
    
    private var additionalView: some View {
        Group {
            Text("Additional Details")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: 30) {
                ForEach(vm.additionalItems) { stat in
                    StatisticsView(statisticsModel: stat)
                }
            }
        }
    }
    
    private var linksView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteLink,
               let url = URL(string: websiteString) {
                    Link("Website", destination: url)
            }
            
            if let redditLinkString = vm.redditLink,
               let url = URL(string: redditLinkString) {
                    Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                CoinDetailView(coin: dev.coin)
                    .preferredColorScheme(.dark)
            }
            
            NavigationStack {
                CoinDetailView(coin: dev.coin)
            }
        }
    }
}
