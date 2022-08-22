//
//  ContentView.swift
//  Bijutune
//
//  Created by 堀内浩樹 on 2022/08/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model: Bijutune = Bijutune()
    @State var searchText = ""
    @State var selectedItem: BijutuneItem = Book(name: "", book: 1, movies: [])
    @State var isShuffle = false
    @State var isActive = false
    @State var isShowThumbnail = true
    
    var destination: some View {
        VStack {
            if selectedItem.isGroup {
                Toggle(isOn: $isShuffle) {
                    HStack {
                        Spacer()
                        Text("シャッフル再生")
                    }
                }.onChange(of: isShuffle) { newValue in
                    model.changeMovie(item: selectedItem, shuffle: newValue)
                }
            }
            
            ZStack {
                VideoView(player: model.player)
                if isShowThumbnail {
                    ThumbnailView(item: selectedItem)
                        .onTapGesture {
                            model.player.play()
                            isShowThumbnail = false
                        }
                }
            }
            
            if selectedItem.isGroup {
                Button(action: {
                    model.player.advanceToNextItem()
                }, label: {
                    Text("Skip >>")
                        .font(.title)
                })
            }
        }
        .navigationBarTitle(selectedItem.name)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(model.filterItems(searchText), id: \.name) { book in
                    Section(book.name) {
                        if searchText.isEmpty {
                            Button {
                                model.changeMovie(item: book, shuffle: isShuffle)
                                self.selectItem(item: book)
                            } label: {
                                BookView(book: book)
                            }
                        }
                        ForEach(book.movies, id: \.name) { movie in
                            Button {
                                model.changeMovie(item: movie)
                                self.selectItem(item: movie)
                            } label: {
                                MovieView(movie: movie)
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
                .searchable(text: $searchText)
                .navigationTitle("びじゅチューン！")
                
                NavigationLink(
                    destination: destination,
                    isActive: $isActive
                ) {
                    EmptyView()
                }
            }
            
            Text("再生したいMovieを選んでね。")
                .font(.largeTitle)
        }
        .task {
            self.model.load()
        }
    }
    
    func selectItem(item: BijutuneItem) {
        selectedItem = item
        isActive = true
        isShowThumbnail = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
