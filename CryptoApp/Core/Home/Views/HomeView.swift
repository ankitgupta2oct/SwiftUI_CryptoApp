//
//  HomeView.swift
//  CryptoApp
//
//  Created by apple on 18/07/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State var showInfo = false
    
    @State var showPortfolio = false
    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()
         
            VStack(spacing: 15) {
                headerView
                
                StatisticsHomeView(showPortfolio: $homeViewModel.isPortfolioPresented)
                
                SearchbarView(searchText: $homeViewModel.searchText)
                    .padding(.horizontal)
                
                titleView
                                
                if (homeViewModel.isPortfolioPresented) {
                    
                    if(homeViewModel.portfolioCoinData.isEmpty && homeViewModel.searchText.isEmpty) {
                        VStack {
                            Spacer()
                            Text("Please add portfolio by clicking on + sign.")
                                .foregroundColor(.theme.accentColor)
                            .font(.headline)
                            .fontWeight(.medium)
                            Spacer()
                            Spacer()
                        }
                    } else {
                        holdingListView
                            .transition(.move(edge: .trailing))
                    }
                }
                else {
                    allCoinsListView
                        .transition(.move(edge: .leading))
                }
                
                Spacer()
            }
        }
    }
}

extension HomeView {
    private var headerView: some View {
        VStack {
            HStack {
                CircularButtonView(iconName: homeViewModel.isPortfolioPresented ? "plus" : "info")
                    .animation(.none, value: homeViewModel.isPortfolioPresented)
                    .onTapGesture {
                        if(homeViewModel.isPortfolioPresented) {
                            showPortfolio = true
                        } else {
                            showInfo = true
                        }
                    }
                    .background {
                        CircularButtonAnimationView(animate: $homeViewModel.isPortfolioPresented)
                            .frame(width: 100, height: 100)
                    }
                Spacer()
                Text(homeViewModel.isPortfolioPresented ? "Portfolio" : "Live Prices")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.accentColor)
                    .animation(.none)
                    .bold()
                Spacer()
                CircularButtonView(iconName: "chevron.right")
                    .rotationEffect(Angle(degrees: homeViewModel.isPortfolioPresented ? 180 : 0))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            homeViewModel.isPortfolioPresented.toggle()
                        }
                    }
            }
            .sheet(isPresented: $showPortfolio, content: {
                PortfolioView()
            })
            .sheet(isPresented: $showInfo, content: {
                InfoView()
                    .presentationDetents([.medium])
            })
            .padding(.horizontal)
        }
    }
    
    private var titleView: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: homeViewModel.sortType == .rank ? 0 : 180.0))
                    .opacity(homeViewModel.sortType == .rank || homeViewModel.sortType == .rankReverse ? 1 : 0)
            }
            .onTapGesture {
                withAnimation(.easeIn) {
                    homeViewModel.sortType = homeViewModel.sortType == .rank ? .rankReverse : .rank
                }
            }
            Spacer()
            if (homeViewModel.isPortfolioPresented) {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .rotationEffect(.init(degrees: homeViewModel.sortType == .holding ? 0 : 180.0))
                        .opacity(homeViewModel.sortType == .holding || homeViewModel.sortType == .holdingReverse ? 1 : 0)
                }
                .onTapGesture {
                    withAnimation(.easeIn) {
                        homeViewModel.sortType = homeViewModel.sortType == .holding ? .holdingReverse : .holding
                    }
                }
            }
            HStack {
                Text("Price")
                    .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: homeViewModel.sortType == .price ? 0 : 180.0))
                    .opacity(homeViewModel.sortType == .price || homeViewModel.sortType == .priceReverse ? 1 : 0)
            }
            .onTapGesture {
                withAnimation(.easeIn) {
                    homeViewModel.sortType = homeViewModel.sortType == .price ? .priceReverse : .price
                }
            }
        }
        .font(.caption)
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var allCoinsListView: some View {
        List {
            ForEach(homeViewModel.allCoins) { coin in
                NavigationLink(value: coin) {
                    CoinRowItem(coinModel: coin, showHoldings: false)
                }
                .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowBackground(Color.theme.backgroundColor)
                .padding(.vertical)
            }
        }
        .refreshable {
            homeViewModel.refreshCoinData()
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .navigationDestination(for: CoinModel.self, destination: { coin in
            CoinDetailView(coin: coin)
        })
    }
    
    private var holdingListView: some View {
        List {
            ForEach(homeViewModel.portfolioCoinData) { coin in
                CoinRowItem(coinModel: coin, showHoldings: true)
                    .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .listRowBackground(Color.theme.backgroundColor)
                    .padding(.vertical)
            }
        }
        .refreshable {
            homeViewModel.refreshPortfolioData()
        }
        .listStyle(.plain)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .preferredColorScheme(.dark)
            
            HomeView()
        }
        .environmentObject(dev.homeViewModel)
    }
}
