//
//  ArtistViewController.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import UIKit

class ArtistViewController: UIViewController {

    @IBOutlet weak var artistCollectionView: UICollectionView!
    var genreID: Int!
    var genreName: String!
    var artistList = [GenreArtist]()

    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var numberOfColumn: CGFloat = 2
    var spacing: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        artistCollectionView.dataSource = self
        artistCollectionView.delegate = self
        getArtist()
    }

    private func getArtist() {
        APICaller.shared.getGenreArtist(with: genreID) { data in
            switch(data)
            {
            case .success(let artist):
                DispatchQueue.main.async {
                    self.artistList = artist.data ?? [GenreArtist]()
                    self.artistCollectionView.reloadData()
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
}

extension ArtistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! ArtistCollectionViewCell

        let artist = artistList[indexPath.row]
        cell.artistLabel.text = artist.name
        downloadImage(from: artist.picture ?? "") { image in
            DispatchQueue.main.async {
                cell.artistImageView.image = image
            }
        }
        return cell
    }
}


extension ArtistViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - (spacing * (numberOfColumn + 1))
        let cellWidth = availableWidth / numberOfColumn
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}
