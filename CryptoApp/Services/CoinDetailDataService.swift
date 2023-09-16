//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by apple on 05/08/23.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetailModel: CoinDetailModel? = nil
    var cancellable: AnyCancellable?
        
    init(coin: CoinModel) {
        getCoinDetail(coin: coin)
//        coinDetailModel = DeveloperPreview.instance.coinDetail
    }
    
    private func getCoinDetail(coin: CoinModel) {
        let coinDetailUrl = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        guard let url = URL(string: coinDetailUrl) else {
            return
        }
        
        cancellable = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coins in
                self?.coinDetailModel = coins
                self?.cancellable?.cancel()
            })
    }
}
