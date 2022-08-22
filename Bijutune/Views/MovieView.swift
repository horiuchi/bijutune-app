//
//  MovieView.swift
//  Bijutune
//
//  Created by 堀内浩樹 on 2022/08/17.
//

import SwiftUI

struct MovieView: View {
    var movie: Movie
    
    var body: some View {
        HStack {
            movie.image
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: nil)
            Text(movie.name)
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movie: Movie(name: "委員長はヴィーナス", book: 1, movie: 1, videoUrl: URL(fileURLWithPath: "book1/1-1.委員長はヴィーナス")))
    }
}
