//
//  Color.swift
//  CryptoApp
//
//  Created by apple on 18/07/23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let accentColor = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    let greenColor = Color("GreenColor")
    let redColor = Color("RedColor")
    let secondaryTextColor = Color("SecondaryTextColor")
}

struct ColorTheme2 {
    let accentColor = Color.red
    let backgroundColor = Color.green
    let greenColor = Color.gray
    let redColor = Color.mint
    let secondaryTextColor = Color.orange
}

struct LaunchTheme {
    let launchAccentColor = Color("LaunchAccentColor")
    let launchBackgroundColor = Color("LaunchBackgroundColor")
}
