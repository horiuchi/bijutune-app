//
//  ThumbnailView.swift
//  Bijutune
//
//  Created by 堀内浩樹 on 2022/08/22.
//

import SwiftUI

struct ThumbnailView: View {
    var item: BijutuneItem
    
    var body: some View {
        ZStack {
            Color.primary
            item.image
                .resizable()
                .scaledToFit()
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(item: Book(name: "DVD BOOK1", book: 1, movies: []))
    }
}
