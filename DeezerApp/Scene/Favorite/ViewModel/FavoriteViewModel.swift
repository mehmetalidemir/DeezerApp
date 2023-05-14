//
//  FavoriteViewModel.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 14.05.2023.
//

import Foundation

class FavoriteViewModel {
    
    var favoriteSongs = [[String: Any]]()
    var onUpdate: (() -> Void)?
    private let apiManager = APIManager.shared
    
    func loadFavorites() {
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
        favoriteSongs = favorites
        onUpdate?()
    }
    
    func removeFavorite(at index: Int) {
        favoriteSongs.remove(at: index)
        UserDefaults.standard.set(favoriteSongs, forKey: "favorites")
        onUpdate?()
    }
    
    func updateSongDuration(for index: Int) {
        let albumID = favoriteSongs[index]["albumID"] as? Int ?? 0
        apiManager.getAlbumSongs(with: albumID) { [weak self] result in
            switch result {
            case .success(let songs):
                if let songDuration = songs.first?.duration {
                    self?.favoriteSongs[index]["duration"] = songDuration
                    self?.onUpdate?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
