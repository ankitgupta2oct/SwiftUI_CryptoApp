//
//  CircularButtonAnimation.swift
//  CryptoApp
//
//  Created by apple on 19/07/23.
//

import SwiftUI

struct CircularButtonAnimationView: View {
    @Binding var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 2)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none , value: animate)
    }
}

struct CircularButtonAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircularButtonAnimationView(animate: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
