//
//  APICaller.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import Foundation

struct Constants {
    static let baseURL = "https://api.deezer.com"
}

enum APIError: Error {
    case InvalidEndpoint
    case DecodingError
}

class APIManager {
    static let shared = APIManager()

    func getGenres(completion: @escaping (Result<Genres, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/genre") else { completion(.failure(APIError.InvalidEndpoint))
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Genres.self, from: data)
                completion(.success(results))
            } catch {
                print(String(describing: error))
                completion(.failure(APIError.DecodingError))
            }
        }
        task.resume()
    }

    func getGenreArtist(with genreId: Int, completion: @escaping (Result<GenreArtists, Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/genre/\(genreId)/artists") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(GenreArtists.self, from: data)
                completion(.success(results))
            } catch {
                print(String(describing: error))
                completion(.failure(APIError.DecodingError))
            }
        }
        task.resume()
    }

    func getArtistAlbums(with artistID: Int, completion: @escaping (Result<ArtistAlbums, Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseURL)/artist/\(artistID)/albums") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(ArtistAlbums.self, from: data)
                completion(.success(results))
            } catch {
                print(String(describing: error))
                completion(.failure(APIError.DecodingError))
            }

        }
        task.resume()
    }
    
    
    func getAlbumSongs(with id: Int, completion: @escaping (Result<[AlbumSong], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/album/\(id)/tracks") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(AlbumSongs.self, from: data)
                completion(.success(results.data ?? [AlbumSong]()))
            }catch{
                print(String(describing: error))
                completion(.failure(APIError.DecodingError))
            }

        }
        task.resume()

    }
}

