//
//  BreedPlaceholderView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 11/10/24.
//

import SwiftUI

struct BreedPlaceholderView: View {
    var body: some View {
        ZStack {
            Color.placeholderForeground
            Image(systemName: "cat")
                .resizable()
                .scaledToFit()
                .padding(16)
                .foregroundStyle(.white)
        }
        .cornerRadius(10)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BreedPlaceholderView()
        .frame(width: 100, height: 100)
}
