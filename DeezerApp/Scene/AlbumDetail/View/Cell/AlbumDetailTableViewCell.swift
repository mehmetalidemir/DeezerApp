//
//  AlbumDetailTableViewCell.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 10.05.2023.
//

import UIKit

class AlbumDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var songFavoriteButton: UIButton!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
