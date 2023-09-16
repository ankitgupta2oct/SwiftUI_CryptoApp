//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by apple on 21/07/23.
//

import Foundation
import Combine

class CoinDataService {
    static let instance = CoinDataService()
    
    @Published var allCoins: [CoinModel] = []
    var cancellable: AnyCancellable?
    
    private let coinUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
    
    private init() {
//        allCoins.insert(contentsOf: DeveloperPreview.instance.coins, at: 0)
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: coinUrl) else {
            return
        }
        
        cancellable = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.cancellable?.cancel()
            })
    }
}
