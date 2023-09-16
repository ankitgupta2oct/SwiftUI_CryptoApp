//
//  CircularButtonView.swift
//  CryptoApp
//
//  Created by apple on 18/07/23.
//

import SwiftUI

struct CircularButtonView: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .frame(width: 50, height: 50)
            .foregroundColor(Color.theme.accentColor)
            .background {
                Circle()
                    .fill(Color.theme.backgroundColor)
                    .shadow(color: Color.theme.accentColor.opacity(0.3), radius: 10, x: 0, y: 0)
            }
    }
}

struct CircularButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircularButtonView(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CircularButtonView(iconName: "plus")
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
