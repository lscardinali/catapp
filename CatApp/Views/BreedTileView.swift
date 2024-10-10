//
//  CatTileView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct CatTileView: View {

    private let cat: Breed

    init(cat: Breed) {
        self.cat = cat
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {

                Image("cat")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                Button {

                } label: {
                    Image(systemName: "star")
                }
                .padding(8)

            }
            Text(cat.name)
                .foregroundStyle(.primary)
                .lineLimit(1)

        }
    }
}

#Preview {
    CatTileView(cat: Breed.mock())
}
