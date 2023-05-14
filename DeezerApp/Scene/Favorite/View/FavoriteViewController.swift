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
    private var viewModel = FavoriteViewModel()
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        navigationItem.title = "Favorites"

        viewModel.onUpdate = { [weak self] in
            self?.favoriteTableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadFavorites()
    }

    private func setupTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.separatorStyle = .none
    }

    @IBAction func favoriteSongButtonTapped(_ sender: Any) {
        guard let cell = (sender as AnyObject).superview?.superview as? FavoriteTableViewCell else { return }
        guard let indexPath = favoriteTableView.indexPath(for: cell) else { return }
        viewModel.removeFavorite(at: indexPath.row)
    }

    private func updateSongDurations() {
        for (index, _) in viewModel.favoriteSongs.enumerated() {
            viewModel.updateSongDuration(for: index)
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
        let count = viewModel.favoriteSongs.count

        if count == 0 {
            let alertController = UIAlertController(title: nil, message: "There are no songs in your favorites.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
        }

        return count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }

        let song = viewModel.favoriteSongs[indexPath.row]
        cell.configure(with: song)

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
            let song = viewModel.favoriteSongs[indexPath.row]
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
