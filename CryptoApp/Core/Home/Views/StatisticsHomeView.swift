//
//  StatisticsHomeView.swift
//  CryptoApp
//
//  Created by apple on 25/07/23.
//

import SwiftUI

struct StatisticsHomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(homeViewModel.stats) { model in
                StatisticsView(statisticsModel: model)
                    .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

struct StatisticsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsHomeView(showPortfolio: .constant(false))
            .environmentObject(dev.homeViewModel)
    }
}
