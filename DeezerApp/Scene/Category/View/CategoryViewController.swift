//
//  ViewController.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var genres = [Genre]()

    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var numberOfColumn: CGFloat = 2
    var spacing: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        getGenres()
        self.title = "Deezer"
    }
    
    private func getGenres() {
        APIManager.shared.getGenres { data in
            switch(data)
            {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.genres = genres.data ?? [Genre]()
                    self.categoryCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = genres[indexPath.row]
        cell.categoryLabel.text = category.name
        cell.categoryImageView.setImage(from: category.picture ?? "")
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGenre = genres[indexPath.row]
        performSegue(withIdentifier: "goToArtist", sender: selectedGenre)
        self.navigationItem.title = selectedGenre.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToArtist", let artistVC = segue.destination as? ArtistViewController, let selectedGenre = sender as? Genre {
            artistVC.genreID = selectedGenre.id
            artistVC.genreName = selectedGenre.name
        }
    }
    
}


extension CategoryViewController: UICollectionViewDelegateFlowLayout {

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
