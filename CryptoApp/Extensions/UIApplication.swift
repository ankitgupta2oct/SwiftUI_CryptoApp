//
//  UIApplication.swift
//  CryptoApp
//
//  Created by apple on 24/07/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditiing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
