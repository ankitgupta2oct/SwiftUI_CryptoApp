//
//  LaunchView.swift
//  CryptoApp
//
//  Created by apple on 07/08/23.
//

import SwiftUI

struct LaunchView: View {
    @Binding var showLaunchView: Bool
    private let loadingText: [String] = "Loading your portfolio...".map({String($0)})
    @State private var showLoadingText = false
    private let timer = Timer.publish(every: 0.1,  on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loop = 0
    
    var body: some View {
        ZStack {
            Color.launch.launchBackgroundColor
                .ignoresSafeArea()
            
            ZStack {
                Image("logo-transparent")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                if showLoadingText {
                    HStack(spacing: 3) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .offset(y: counter == index ? -10 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                    .font(.headline)
                    .bold()
                    .offset(y: 70)
                    .foregroundColor(Color.launch.launchAccentColor)
                }
            }
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                self.counter += 1
                
                let lastIndex = loadingText.count - 1
                if (counter == lastIndex) {
                    counter = 0
                    loop += 1
                    
                    if(loop > 1) {
                        showLaunchView = false
                    }
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
