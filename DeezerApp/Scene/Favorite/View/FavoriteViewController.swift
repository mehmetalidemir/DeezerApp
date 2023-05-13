//
//  FavoriteViewController.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 11.05.2023.
//

import UIKit
import AVFAudio

class FavoriteViewController: UIViewController {
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteSongs = [[String: Any]]()
    var timer: Timer?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadFavorites()
    }

    private func setupTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.separatorStyle = .none
    }

    private func loadFavorites() {
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
        favoriteSongs = favorites
        favoriteTableView.reloadData()
    }

    @IBAction func favoriteSongButtonTapped(_ sender: Any) {
        guard let cell = (sender as AnyObject).superview?.superview as? FavoriteTableViewCell else { return }
        guard let indexPath = favoriteTableView.indexPath(for: cell) else { return }
        favoriteSongs.remove(at: indexPath.row)

        UserDefaults.standard.set(favoriteSongs, forKey: "favorites")

        favoriteTableView.deleteRows(at: [indexPath], with: .automatic)

        let image = UIImage(systemName: "heart.fill")
        (sender as AnyObject).setImage(image, for: .normal)
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
       guard let url = URL(string: urlString) else {
          completion(nil)
          return
       }

       DispatchQueue.global().async {
          if let data = try? Data(contentsOf: url),
             let image = UIImage(data: data) {
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


    private func updateSongDurations() {
        for (index, favorite) in favoriteSongs.enumerated() {
            let albumID = favorite["albumID"] as? Int ?? 0

            APIManager.shared.getAlbumSongs(with: albumID) { [weak self] result in
                switch result {
                case .success(let songs):
                    DispatchQueue.main.async {
                        if let songDuration = songs.first?.duration {
                            self?.favoriteSongs[index]["duration"] = songDuration
                            self?.favoriteTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func downloadFileFromURL(url: URL, startTime: TimeInterval = 0) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (url, response, error) in
            guard let self = self, let url = url else { return }
            self.play(url: url, startTime: startTime)
        }
        downloadTask.resume()
    }

    private func stopAudio() {
        if let audioPlayer = self.audioPlayer {
            audioPlayer.stop()
        }
        timer?.invalidate()
        timer = nil
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

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }

        let song = favoriteSongs[indexPath.row]
        cell.favoriteSongLabel.text = song["title"] as? String ?? ""
        let duration = song["duration"] as? Int ?? 0
        let minutes = duration / 60
        cell.favoriteSongDurationLabel.text = "\(minutes):\(duration % 60)"

        if let albumPhotoURL = song["albumPhotoURL"] as? String {
           cell.favoriteImageView.image = nil
           downloadImage(from: albumPhotoURL) { image in
              cell.favoriteImageView.image = image
           }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            stopAudio()
        } else {
            let song = favoriteSongs[indexPath.row]
            guard let track = song["preview"] as? String, let url = URL(string: track) else { return }
            let startTime = audioPlayer?.currentTime ?? 0
            downloadFileFromURL(url: url, startTime: startTime)

            let duration = TimeInterval(song["duration"] as? Int ?? 0)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let currentSeconds = Int(self.audioPlayer?.currentTime ?? 0)
                let currentMinutes = currentSeconds / 60
                let remainingSeconds = Int(duration - (self.audioPlayer?.currentTime ?? 0))
                let _ = remainingSeconds / 60

                let indexPath = IndexPath(row: indexPath.row, section: 0)
                if let cell = self.favoriteTableView.cellForRow(at: indexPath) as? FavoriteTableViewCell {
                    cell.favoriteSongDurationLabel.text = "\(currentMinutes):\(String(format: "%02d", currentSeconds % 60))"
                }
            }
        }
    }
}
