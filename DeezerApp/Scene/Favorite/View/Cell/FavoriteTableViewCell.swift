//
//  FavoriteTableViewCell.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 11.05.2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteViewButton: UIButton!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteSongDurationLabel: UILabel!
    @IBOutlet weak var favoriteSongLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}
