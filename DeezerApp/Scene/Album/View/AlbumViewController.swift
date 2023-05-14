//
//  AlbumViewController.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var artistCoverImageView: UIImageView!
    @IBOutlet weak var albumTableView: UITableView!
    private var viewModel: AlbumViewModel!

    var artistID: Int!
    var artistName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureViewModel()
    }

    private func setup() {
        albumTableView.delegate = self
        albumTableView.dataSource = self
        self.albumTableView.separatorStyle = .none

        navigationController?.navigationBar.tintColor = UIColor.red
        title = artistName
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func configureViewModel() {
        viewModel = AlbumViewModel(apiManager: APIManager.shared)
        viewModel.getArtistAlbums(with: artistID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.albumTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func convertDate(dateString: String?) -> String? {
        guard let dateString = dateString else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)

        return year
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artistAlbums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell

        let album = viewModel.artistAlbums[indexPath.row]

        cell.albumNameLabel?.text = album.title
        cell.albumReleaseDateLabel?.text = convertDate(dateString: album.release_date)
        cell.albumImageView.setImage(from: album.cover)
        cell.albumImageView.image = UIImage(named: "placeholder")


        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = viewModel.artistAlbums[indexPath.row]
        performSegue(withIdentifier: "goToAlbumDetail", sender: artist)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAlbumDetail", let albumDetailVC = segue.destination as? AlbumDetailViewController, let album = sender as? ArtistAlbum {
            albumDetailVC.albumID = album.id
            albumDetailVC.albumName = album.title
            albumDetailVC.albumPhotoURL = URL(string: album.cover ?? "")
        }
    }
}
