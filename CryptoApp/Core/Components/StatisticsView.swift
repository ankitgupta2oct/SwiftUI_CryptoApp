//
//  StatisticsView.swift
//  CryptoApp
//
//  Created by apple on 25/07/23.
//

import SwiftUI

struct StatisticsView: View {
    let statisticsModel: StatisticsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(statisticsModel.title)
                .foregroundColor(.theme.secondaryTextColor)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            
            Text(statisticsModel.value)
                .font(.headline)
                .bold()
            HStack(spacing: 3) {
                Image(systemName: getIcon(value: statisticsModel.percantageValue))
                    .foregroundColor(getIconColor(value: statisticsModel.percantageValue))
                Text((statisticsModel.percantageValue ?? 0).asPercentageString())
                    .foregroundColor(getIconColor(value: statisticsModel.percantageValue))
                    .font(.headline)
            }
            .opacity(statisticsModel.percantageValue != nil ? 1 : 0)
        }
    }
    
    func getIcon(value: Double?) -> String {
        guard let value = value, value != 0 else {
            return "circle.fill"
        }
        
        return value > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
    }
    
    func getIconColor(value: Double?) -> Color {
        guard let value = value, value != 0 else {
            return .primary
        }
        
        return value > 0 ? .theme.greenColor : .theme.redColor
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsView(statisticsModel: dev.stat1)
                .previewLayout(.sizeThatFits)
            StatisticsView(statisticsModel: dev.stat2)
                .previewLayout(.sizeThatFits)
            StatisticsView(statisticsModel: dev.stat3)
                .previewLayout(.sizeThatFits)
        }
    }
}
