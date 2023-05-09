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
    }
    
    private func getGenres() {
        APICaller.shared.getGenres { data in
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

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell

        let category = genres[indexPath.row]
        cell.categoryLabel.text = category.name
        downloadImage(from: category.picture ?? "") { image in
            DispatchQueue.main.async {
                cell.categoryImageView.image = image
            }
        }
        return cell
    }
}


extension CategoryViewController: UICollectionViewDelegateFlowLayout {

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
