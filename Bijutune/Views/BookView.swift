//
//  BooksView.swift
//  Bijutune
//
//  Created by 堀内浩樹 on 2022/08/17.
//

import SwiftUI

struct BookView: View {
    var book: Book
    
    var body: some View {
        HStack {
            book.image
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: nil)
            Text("全て再生")
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: Book(name: "DVD Book1", book: 1, movies: []))
    }
}
