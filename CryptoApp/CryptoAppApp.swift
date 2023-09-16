//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by apple on 18/07/23.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    let homeViewModel = HomeViewModel()
    @State var showLaunchView = true
    
    init() {
        URLCache.shared.memoryCapacity = 10_000_000 // ~10 MB memory space
        URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB disk cache space
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accentColor)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                }
                .environmentObject(homeViewModel)
                
                ZStack {
                    if(showLaunchView) {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
