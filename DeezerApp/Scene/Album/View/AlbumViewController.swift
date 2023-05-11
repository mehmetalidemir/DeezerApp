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
    var artistID: Int!
    var artistName: String!
    var artistAlbums = [ArtistAlbum]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }

    private func setup() {
        albumTableView.delegate = self
        albumTableView.dataSource = self
        self.albumTableView.separatorStyle = .none

        navigationController?.navigationBar.tintColor = UIColor.red
        title = artistName
        navigationController?.navigationBar.prefersLargeTitles = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            getArtistAlbums()
        }
    }

    private func getArtistAlbums() {

        APICaller.shared.getArtistAlbums(with: artistID) { data in
            switch(data)
            {
            case .success(let album):
                DispatchQueue.main.async {
                    self.artistAlbums = album.data ?? [ArtistAlbum]()
                    self.albumTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
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
        return artistAlbums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell

        let album = artistAlbums[indexPath.row]

        cell.albumNameLabel?.text = album.title
        cell.albumReleaseDateLabel?.text = convertDate(dateString: album.release_date)

        cell.albumImageView.image = UIImage(named: "placeholder")
        downloadImage(from: album.cover ?? "") { image in
            DispatchQueue.main.async {
                cell.albumImageView.image = image
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artistAlbums[indexPath.row]
        performSegue(withIdentifier: "goToAlbumDetail", sender: artist)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAlbumDetail", let albumDetailVC = segue.destination as? AlbumDetailViewController, let album = sender as? ArtistAlbum {
            albumDetailVC.albumID = album.id
            albumDetailVC.albumName = album.title
            albumDetailVC.albumPhotoURL = album.cover
        }
    }
}
