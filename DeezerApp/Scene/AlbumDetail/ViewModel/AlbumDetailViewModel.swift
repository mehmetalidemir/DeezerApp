//
//  AlbumDetailViewModel.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 14.05.2023.
//

import UIKit
import AVFAudio

class AlbumDetailViewModel {
    var audioPlayer: AVAudioPlayer?

    var albumID: Int?
    var albumName: String!
    var albumPhotoURL: URL?
    var timer: Timer?

    var songList: [AlbumSong] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var reloadTableViewClosure: (() -> ())?

    func getSongs() {
        guard let albumID = albumID else { return }
        APIManager.shared.getAlbumSongs(with: albumID) { result in
            switch result {
            case .success(let songs):
                DispatchQueue.main.async {
                    self.songList = songs
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func addToFavorites(song: AlbumSong) {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []

        let isAlreadyFavorite = favorites.contains(where: { $0["id"] as? Int == song.id })
        if isAlreadyFavorite {
            print("This song is already in favorites")
            favorites.removeAll(where: { $0["id"] as? Int == song.id })
        } else {
            let favoriteSong: [String: Any] = [
                "id": song.id ?? 0,
                "title": song.title ?? "",
                "artist": song.artist?.name ?? "",
                "duration": song.duration ?? 0,
                "preview": song.preview ?? "",
                "albumPhotoURL": albumPhotoURL?.absoluteString ?? ""
            ]

            favorites.append(favoriteSong)
        }

        UserDefaults.standard.set(favorites, forKey: "favorites")
        print("Song added to favorites")
    }



    func downloadFileFromURL(url: URL, startTime: TimeInterval = 0) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (url, response, error) in
            guard let self = self, let url = url else { return }
            self.play(url: url, startTime: startTime)
        }
        downloadTask.resume()
    }

    func play(url: URL, startTime: TimeInterval = 0) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.currentTime = startTime
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
                self?.audioPlayer?.stop()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
