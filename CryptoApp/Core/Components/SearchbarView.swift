//
//  SearchbarView.swift
//  CryptoApp
//
//  Created by apple on 24/07/23.
//

import SwiftUI

struct SearchbarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? Color.theme.secondaryTextColor : Color.theme.accentColor)
            TextField("Enter the text", text: $searchText)
                .foregroundColor(Color.theme.accentColor)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.accentColor)
                        .padding()
                        .offset(x: 20)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditiing()
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.backgroundColor)
                .shadow(color: Color.theme.accentColor.opacity(searchText.isEmpty ? 0.15 : 0.5),
                        radius: 5, x: 0, y: 0)
        }
    }
}

struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchbarView(searchText: .constant(""))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            SearchbarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
        }
    }
}
