//
//  XmarkButtonView.swift
//  CryptoApp
//
//  Created by apple on 26/07/23.
//

import SwiftUI

struct XmarkButtonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.accentColor)
        }
    }
}

struct XmarkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButtonView()
    }
}
