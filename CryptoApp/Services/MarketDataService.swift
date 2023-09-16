//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by apple on 25/07/23.
//

import Foundation
import Combine

class MarketDataService {
    static let instance = MarketDataService()
    
    @Published var marketData: MarketDataModel? = nil
    var cancellable: AnyCancellable?
    
    private let coinUrl = "https://api.coingecko.com/api/v3/global"
    
    private init() {
//        marketData = DeveloperPreview.instance.marketData
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: coinUrl) else {
            return
        }
        
        cancellable = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.cancellable?.cancel()
            })
    }
}
