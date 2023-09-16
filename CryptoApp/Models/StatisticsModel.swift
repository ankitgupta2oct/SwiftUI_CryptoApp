//
//  StatisticsModel.swift
//  CryptoApp
//
//  Created by apple on 25/07/23.
//

import Foundation

struct StatisticsModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percantageValue: Double?
    
    init(title: String, value: String, percantageValue: Double? = nil) {
        self.title = title
        self.value = value
        self.percantageValue = percantageValue
    }
}
