//
//  CatTileView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct CatTileView: View {

    private let cat: Cat

    init(cat: Cat) {
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
        }
    }
}

#Preview {
    CatTileView(cat: Cat(id: 1, name: "Siamese"))
}
