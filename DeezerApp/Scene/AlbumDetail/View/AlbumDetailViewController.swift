//
//  AlbumDetailViewController.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 10.05.2023.
//

import UIKit
import AVFAudio

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var albumDetailTableView: UITableView!
    var audioPlayer: AVAudioPlayer?
    var songList = [AlbumSong]()
    var albumID: Int?
    var albumName: String!
    var albumPhotoURL: String!
    var timer: Timer?
    var duration: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        albumDetailTableView.delegate = self
        albumDetailTableView.dataSource = self
        albumDetailTableView.separatorStyle = .none
        getSongs()
    }
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let song = songList[sender.tag]
            addToFavorites(sender, song: song)
    }

    func addToFavorites(_ sender: UIButton, song: AlbumSong) {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []

        let isAlreadyFavorite = favorites.contains(where: { $0["id"] as? Int == song.id })
        if isAlreadyFavorite {
            print("This song is already in favorites")
            favorites.removeAll(where: { $0["id"] as? Int == song.id })
            let image = UIImage(systemName: "heart")
            sender.setImage(image, for: .normal)
        } else {
            let favoriteSong: [String: Any] = [
                "id": song.id ?? 0,
                "title": song.title ?? "",
                "artist": song.artist?.name ?? "",
                "duration": song.duration ?? 0,
                "preview": song.preview ?? "",
                "albumPhotoURL" : albumPhotoURL ?? ""
            ]

            favorites.append(favoriteSong)
            let image = UIImage(systemName: "heart.fill")
            sender.setImage(image, for: .normal)
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

    private func getSongs() {
        guard let albumID = albumID else { return }
        APIManager.shared.getAlbumSongs(with: albumID) { result in
            switch result {
            case .success(let songs):
                DispatchQueue.main.async {
                    self.songList = songs
                    self.albumDetailTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = try? Data(contentsOf: url),

                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumDetailCell", for: indexPath) as? AlbumDetailTableViewCell else {
            return UITableViewCell()
        }

        let song = songList[indexPath.row]
        cell.songNameLabel.text = song.title

        let seconds = song.duration ?? 0
        let minutes = seconds / 60
        cell.songDurationLabel.text = "\(minutes):\(seconds % 60)"

        if let albumPhotoURL = albumPhotoURL {
            downloadImage(from: albumPhotoURL) { image in
                cell.songImageView.image = image
            }
        }

        cell.songFavoriteButton.tag = indexPath.row

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
            timer?.invalidate()
            timer = nil
        } else {
            let song = songList[indexPath.row]

            guard let track = song.preview, let url = URL(string: track) else { return }
            let startTime = audioPlayer?.currentTime ?? 0
            downloadFileFromURL(url: url, startTime: startTime)

            let duration = TimeInterval(song.duration ?? 0)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let currentSeconds = Int(self.audioPlayer?.currentTime ?? 0)
                let currentMinutes = currentSeconds / 60
                let remainingSeconds = Int(duration - (self.audioPlayer?.currentTime ?? 0))
                let _ = remainingSeconds / 60

                let indexPath = IndexPath(row: indexPath.row, section: 0)
                if let cell = self.albumDetailTableView.cellForRow(at: indexPath) as? AlbumDetailTableViewCell {
                    cell.songDurationLabel.text = "\(currentMinutes):\(String(format: "%02d", currentSeconds % 60))"
                }
            }
        }
    }
}
