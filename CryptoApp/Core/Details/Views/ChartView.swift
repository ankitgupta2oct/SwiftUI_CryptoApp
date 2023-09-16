//
//  ChartView.swift
//  CryptoApp
//
//  Created by apple on 06/08/23.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let minY: Double
    private let maxY: Double
    private let lineColor: Color
    private let startDate: Date
    private let endDate: Date
    @State private var lineDrawValue: CGFloat = 0.0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        
        startDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        endDate = startDate.addingTimeInterval(-7*24*60*60)
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.greenColor : Color.theme.redColor
    }
    
    var body: some View {
        VStack {
            chartView
                .background(chartViewBackground)
                .overlay(alignment: .leading) {
                    chartViewOverlay
                        .padding(.horizontal, 4)
                }
            
            chartDatesView
                .padding(.horizontal, 4)
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2)) {
                    lineDrawValue = 1.0
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryTextColor)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometryReader in
            Path { path in
                for index in data.indices {
                    let xPosition = geometryReader.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometryReader.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: lineDrawValue)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartViewBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartViewOverlay: some View {
        VStack {
            Text("\(maxY.formattedWithAbbreviations())")
            Spacer()
            Text("\(((minY + maxY) / 2).formattedWithAbbreviations())")
            Spacer()
            Text("\(minY.formattedWithAbbreviations())")
        }
    }
    
    private var chartDatesView: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChartView(coin: dev.coin)
                .frame(width: .infinity, height: 300)
                .preferredColorScheme(.dark)
            
            ChartView(coin: dev.coin)
                .frame(width: .infinity, height: 300)
        }
        .previewLayout(.sizeThatFits)
    }
}
