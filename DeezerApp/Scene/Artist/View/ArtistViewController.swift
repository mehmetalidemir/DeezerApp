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

    private let viewModel = ArtistViewModel(apiManager: APIManager.shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchArtistData()
    }

    private func setupCollectionView() {
        artistCollectionView.dataSource = self
        artistCollectionView.delegate = self
    }

    private func fetchArtistData() {
        viewModel.getArtist(with: genreID) { [weak self] result in
            switch result {
            case .success:
                self?.artistCollectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAlbum", let albumVC = segue.destination as? AlbumViewController, let artist = sender as? GenreArtist {
            albumVC.artistID = artist.id
            albumVC.artistName = artist.name
            viewModel.downloadImage(from: artist.picture_big ?? "") { image in
                DispatchQueue.main.async {
                    albumVC.artistCoverImageView.image = image
                }
            }
        }
    }
}

extension ArtistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.artistList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! ArtistCollectionViewCell

        let artist = viewModel.artistList[indexPath.row]
        cell.artistLabel.text = artist.name
        cell.artistImageView.setImage(from: artist.picture ?? "")

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = viewModel.artistList[indexPath.row]
        performSegue(withIdentifier: "goToAlbum", sender: artist)
    }
}

extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: viewModel.spacing, left: viewModel.spacing, bottom: viewModel.spacing, right: viewModel.spacing)
    }
}
