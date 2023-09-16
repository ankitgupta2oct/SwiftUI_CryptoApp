//
//  InfoView.swift
//  CryptoApp
//
//  Created by apple on 07/08/23.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    Text("Hey, I am Ankit Gupta.\n Learing SwiftUI...")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(Color.theme.accentColor)
                .navigationTitle("About Me")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XmarkButtonView()
                    }
            }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
