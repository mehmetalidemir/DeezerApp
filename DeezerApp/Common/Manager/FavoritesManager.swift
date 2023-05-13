//
//  FavoritesManager.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 12.05.2023.
//

import Foundation

class FavoritesManager {

    static let shared = FavoritesManager()
    private let favoriteSongsKey = "favoriteSongs"

    private init() { }

    func saveFavoriteSong(_ song: AlbumSong) {
        var favoriteSongs = getFavoriteSongs()
        favoriteSongs.append(song)
        if let data = try? JSONEncoder().encode(favoriteSongs) {
            UserDefaults.standard.set(data, forKey: favoriteSongsKey)
        }
    }

    func removeFavoriteSong(_ song: AlbumSong) {
        var favoriteSongs = getFavoriteSongs()
        favoriteSongs.removeAll { $0.id == song.id }
        if let data = try? JSONEncoder().encode(favoriteSongs) {
            UserDefaults.standard.set(data, forKey: favoriteSongsKey)
        }
    }

    func isSongFavorited(_ song: AlbumSong) -> Bool {
        let favoriteSongs = getFavoriteSongs()
        return favoriteSongs.contains { $0.id == song.id }
    }

    func getFavoriteSongs() -> [AlbumSong] {
        if let data = UserDefaults.standard.data(forKey: favoriteSongsKey),
            let favoriteSongs = try? JSONDecoder().decode([AlbumSong].self, from: data) {
            return favoriteSongs
        }
        return []
    }
}
