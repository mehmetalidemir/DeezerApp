//
//  AlbumViewModel.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 14.05.2023.
//

import Foundation

class AlbumViewModel {
private let apiManager: APIManager
    var artistAlbums = [ArtistAlbum]()

init(apiManager: APIManager) {
    self.apiManager = apiManager
}

func getArtistAlbums(with artistID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    apiManager.getArtistAlbums(with: artistID) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let album):
            if let albums = album.data {
                self.artistAlbums = albums
                completion(.success(()))
            } else {
                let error = NSError(domain: "No data found", code: 404, userInfo: nil)
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
}
