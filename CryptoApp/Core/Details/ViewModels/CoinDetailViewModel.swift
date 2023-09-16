//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by apple on 05/08/23.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    @Published var overViewItems: [StatisticsModel] = []
    @Published var additionalItems: [StatisticsModel] = []
    @Published var description: String? = nil
    @Published var websiteLink: String? = nil
    @Published var redditLink: String? = nil
    
    let coinDetailDataService: CoinDetailDataService
    let coin: CoinModel
    var cancellable: Set<AnyCancellable> = []
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        coinDetailDataService.$coinDetailModel
            .map(mapDataToStatices)
            .sink { [weak self] (returnedArray) in
                self?.overViewItems = returnedArray.overviewItems
                self?.additionalItems = returnedArray.additionalItems
            }
            .store(in: &cancellable)
        
        coinDetailDataService.$coinDetailModel
            .sink { [weak self] coinDetail in
                self?.description = coinDetail?.readableDescription
                self?.websiteLink = coinDetail?.links?.homepage?.first
                self?.redditLink = coinDetail?.links?.subredditURL
            }
            .store(in: &cancellable)
    }
    
    private func mapDataToStatices(coinDetail: CoinDetailModel?) -> (overviewItems: [StatisticsModel], additionalItems: [StatisticsModel]) {
        let overviewItems = getOverviewItemsArray()
        let additionalItems = getAdditionalItemsArray(coinDetail: coinDetail)
        return (overviewItems, additionalItems)
    }
    
    private func getOverviewItemsArray() -> [StatisticsModel] {
        let price = coin.currentPrice.asCurrencyWith2Decimals()
        let pricePerChange = coin.priceChangePercentage24H
        let pricestat = StatisticsModel(title: "Current Price", value: price, percantageValue: pricePerChange)
        
        let marketCap = coin.marketCap?.formattedWithAbbreviations() ?? ""
        let marketcapPerChange = coin.marketCapChangePercentage24H
        let marketcapStat = StatisticsModel(title: "market Capitalization", value: marketCap, percantageValue: marketcapPerChange)
        
        let rank = "\(coin.rank)"
        let rankStat = StatisticsModel(title: "Rank", value: rank)
        
        let volume = coin.totalVolume?.formattedWithAbbreviations() ?? ""
        let volumeStat = StatisticsModel(title: "Volume", value: volume)
        
        return [pricestat, marketcapStat, rankStat, volumeStat]
    }
    
    private func getAdditionalItemsArray(coinDetail: CoinDetailModel?) -> [StatisticsModel] {
        let high = coin.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let highStat = StatisticsModel(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith2Decimals() ?? "n/a"
        let lowStat = StatisticsModel(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let priceperChange2 = coin.priceChangePercentage24H
        let priceStat = StatisticsModel(title: "24h Price Change", value: priceChange, percantageValue: priceperChange2)
        
        let marketCapChange = coin.marketCapChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let marketCapPerChange = coin.marketCapChangePercentage24H
        let priceStat1 = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percantageValue: marketCapPerChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hasing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashStst = StatisticsModel(title: "Hashing Algorithm", value: hasing)

        return [highStat, lowStat, priceStat, priceStat1, blockStat, hashStst]
    }
}
