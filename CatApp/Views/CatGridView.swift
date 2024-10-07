//
//  CatGridView.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import SwiftUI

struct CatGridView: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))] ) {
            ForEach(0..<20) { index in
                CatTileView(cat: Cat(id: 1, name: "Siamese"))
            }
        }
    }
}

#Preview {
    CatGridView()
}
