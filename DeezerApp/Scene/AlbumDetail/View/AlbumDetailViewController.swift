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
    var viewModel = AlbumDetailViewModel()
    var timer: Timer?
    var albumID: Int?
    var albumName: String?
    var albumPhotoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        albumDetailTableView.delegate = self
        albumDetailTableView.dataSource = self
        albumDetailTableView.separatorStyle = .none

        viewModel.albumID = albumID
        viewModel.albumName = albumName
        viewModel.albumPhotoURL = albumPhotoURL
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.albumDetailTableView.reloadData()
        }

        viewModel.getSongs()
    }


    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let song = viewModel.songList[sender.tag]
        viewModel.addToFavorites(song: song)

        var imageName = "heart"
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
        let isAlreadyFavorite = favorites.contains(where: { $0["id"] as? Int == song.id })
        if isAlreadyFavorite {
            imageName = "heart.fill"
        }
        let image = UIImage(systemName: imageName)
        sender.setImage(image, for: .normal)
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumDetailCell", for: indexPath) as? AlbumDetailTableViewCell else {
            return UITableViewCell()
        }

        let song = viewModel.songList[indexPath.row]
        cell.songNameLabel.text = song.title

        let seconds = song.duration ?? 0
        let minutes = seconds / 60
        cell.songDurationLabel.text = "\(minutes):\(seconds % 60)"

        if let albumPhotoURL = viewModel.albumPhotoURL {
            cell.songImageView.setImage(from: albumPhotoURL.absoluteString)
        } else {
            cell.songImageView.image = UIImage(named: "placeholder")
        }

        cell.songFavoriteButton.tag = indexPath.row

        var imageName = "heart"
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
        let isAlreadyFavorite = favorites.contains(where: { $0["id"] as? Int == song.id })
        if isAlreadyFavorite {
            imageName = "heart.fill"
        }
        let image = UIImage(systemName: imageName)
        cell.songFavoriteButton.setImage(image, for: .normal)

        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let audioPlayer = viewModel.audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
            timer?.invalidate()
            timer = nil
        } else {
            let song = viewModel.songList[indexPath.row]

            guard let track = song.preview, let url = URL(string: track) else { return }
            let startTime = viewModel.audioPlayer?.currentTime ?? 0
            viewModel.downloadFileFromURL(url: url, startTime: startTime)

            let duration = TimeInterval(song.duration ?? 0)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let currentSeconds = Int(self.viewModel.audioPlayer?.currentTime ?? 0)
                let currentMinutes = currentSeconds / 60
                let remainingSeconds = Int(duration - (self.viewModel.audioPlayer?.currentTime ?? 0))
                let _ = remainingSeconds / 60

                let indexPath = IndexPath(row: indexPath.row, section: 0)
                if let cell = self.albumDetailTableView.cellForRow(at: indexPath) as? AlbumDetailTableViewCell {
                    cell.songDurationLabel.text = "\(currentMinutes):\(String(format: "%02d", currentSeconds % 60))"
                }
            }
        }
    }
}

