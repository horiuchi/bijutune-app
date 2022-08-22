import Foundation
import SwiftUI
import AVKit

class Bijutune: ObservableObject {
    @Published var bijutuneItems: [Book] = []
    @Published var player: AVQueuePlayer = AVQueuePlayer(items: [])
    
    let MaxBookIndex = 6
    
    func load() {
        self.bijutuneItems = self.loadData()
    }
    
    func changeMovie(item: BijutuneItem, shuffle: Bool = false) {
        player.pause()
        player.removeAllItems()
        item.getMovie(shuffle: shuffle).forEach { movie in
            player.insert(movie, after: nil)
        }
    }
    
    func filterItems(_ searchText: String) -> [Book] {
        if searchText.isEmpty {
            return self.bijutuneItems
        }
        let books = self.bijutuneItems.map { book -> Book in
            let movies = book.movies.filter { $0.name.contains(searchText) }
            return Book(name: book.name, book: book.book, movies: movies)
        }
        return books.filter { $0.movies.count > 0 }
    }

    private func loadData() -> [Book] {
        return Array(1...MaxBookIndex).map { i in
            guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp4", subdirectory: "book\(i)") else {
                fatalError("Fail to load the movies data.")
            }
            let movies = urls.compactMap{ url -> Movie? in
                var path = url.relativePath
                path.removeLast(url.pathExtension.count + 1)
                
                guard let index = path.firstIndex(of: "-") else {
                    return nil
                }
                let number = path.prefix(upTo: index)
                guard let movie = Int(number) else {
                    return nil
                }
                
                guard let index = path.firstIndex(of: ".") else {
                    return nil
                }
                let name = path.suffix(from: path.index(after: index))
                
                return Movie(name: String(name), book: i, movie: movie, videoUrl: url)
            }
            return Book(name: "DVD BOOK\(i)", book: i, movies: movies.sorted { $0.movie < $1.movie })
        }
    }
}

protocol BijutuneItem {
    var id: String { get }
    var isGroup: Bool { get }
    var name: String { get }
    var image: Image { get }
    
    func getMovie(shuffle: Bool) -> [AVPlayerItem]
}

struct Book: BijutuneItem {
    var isGroup = true
    var name: String
    var book: Int
    var movies: [Movie]
    
    var id: String {
        "bijutune\(book)"
    }
    var image: Image {
        Image(self.id)
    }
    
    func getMovie(shuffle: Bool) -> [AVPlayerItem] {
        var items = self.movies.map { movie -> AVPlayerItem in
            return AVPlayerItem(url: movie.videoUrl)
        }
        if shuffle {
            items.shuffle()
        }
        return items
    }
}

struct Movie: BijutuneItem {
    var isGroup = false
    var name: String
    var book: Int
    var movie: Int
    var videoUrl: URL
    
    var id: String {
        "book\(book)/movie\(movie)"
    }
    var image: Image {
        Image(self.id)
    }
    
    func getMovie(shuffle: Bool) -> [AVPlayerItem] {
        return [AVPlayerItem(url: self.videoUrl)]
    }
}

