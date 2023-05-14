//
//  ArtistViewModel.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 14.05.2023.
//

import Foundation
import UIKit

class ArtistViewModel {

    private let apiManager: APIManager

    var artistList = [GenreArtist]()
    var selectedArtist: Artist!

    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var numberOfColumn: CGFloat = 2
    var spacing: CGFloat = 12

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    func getArtist(with genreID: Int, completion: @escaping (Result<[GenreArtist], Error>) -> Void) {
        apiManager.getGenreArtist(with: genreID) { result in
            switch(result)
            {
            case .success(let artist):
                DispatchQueue.main.async {
                    self.artistList = artist.data ?? [GenreArtist]()
                    completion(.success(self.artistList))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("error \(error!.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Image data is empty")
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}
