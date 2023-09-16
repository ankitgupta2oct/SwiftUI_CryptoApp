//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by apple on 21/07/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var stats: [StatisticsModel] = []
    @Published var portfolioCoinData: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isPortfolioPresented = false
    @Published var sortType: SortType = .rank
    
    enum SortType {
        case rank, rankReverse, price, priceReverse, holding, holdingReverse
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    let coinDataService = CoinDataService.instance
    let marketDataService = MarketDataService.instance
    let portfolioDataService = PortfolioDataService.instance
    
    init() {
        addSubscriptions()
    }
    
    func addSubscriptions() {
        
        // Search
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortType)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSort)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
                
        // Portfolio data
        $allCoins
            .combineLatest(portfolioDataService.$portfolioData)
            .map(mapPortfolioData)
            .sink { [weak self] coins in
                self?.portfolioCoinData = coins
            }
            .store(in: &cancellables)
        
        // Market Data
        marketDataService.$marketData
            .combineLatest($portfolioCoinData)
            .map(mapMarketData)
            .sink { [weak self] statisticsModelList in
                self?.stats = statisticsModelList
            }
            .store(in: &cancellables)
    }
    
    func refreshCoinData() {
        coinDataService.getCoins()
        marketDataService.getMarketData()
    }
    
    func refreshPortfolioData() {
        portfolioDataService.fetchPortfolio()
    }
    
    private func filterAndSort(searchText: String, coins: [CoinModel], sortType: SortType) -> [CoinModel] {
        var updatedCoins = filterCoins(searchText: searchText, coins: coins)
        sortCoins(sortType: sortType, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(searchText: String, coins: [CoinModel]) -> [CoinModel] {
        guard !searchText.isEmpty else {
            return coins
        }
        
        let lowerText = searchText.lowercased()
        return coins.filter { coin in
            return coin.id.lowercased().contains(lowerText) ||
                coin.symbol.lowercased().contains(lowerText) ||
                coin.name.lowercased().contains(lowerText)
        }
    }
    
    private func sortCoins(sortType: SortType, coins: inout [CoinModel]) {
        switch sortType {
        case .rank, .holding:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReverse, .holdingReverse:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReverse:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func mapPortfolioData(coinModels: [CoinModel], portfolioEntity: [PortfolioEntity]) -> [CoinModel] {
        return coinModels.compactMap { coin in
            guard let selectedPortfolio = portfolioEntity.first(where: {$0.coinId == coin.id}) else {
                return nil
            }
            
            return coin.updateHoldings(amount: selectedPortfolio.amount)
        }
    }
    
    private func mapMarketData(marketData: MarketDataModel?, portfolioCoinData: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        
        guard let marketData = marketData else {
            return stats
        }
        
        let portfolioValue = portfolioCoinData
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portfolioCoinData
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let stat1 = StatisticsModel(title: "Market Cap", value: marketData.marketCap, percantageValue: marketData.marketCapChangePercentage24HUsd)
        let stat2 = StatisticsModel(title: "24 Volume", value: marketData.volume)
        let stat3 = StatisticsModel(title: "BTC Dominance", value: marketData.btcDominance)
        let stat4 = StatisticsModel(title: "Portfolio", value: portfolioValue.asCurrencyWith2Decimals(), percantageValue: percentageChange)
        
        stats.append(contentsOf: [
            stat1,
            stat2,
            stat3,
            stat4
        ])
        return stats
    }
}
