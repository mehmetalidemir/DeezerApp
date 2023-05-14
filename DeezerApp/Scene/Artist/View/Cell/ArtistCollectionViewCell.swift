//
//  ArtistCollectionViewCell.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var artistImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
