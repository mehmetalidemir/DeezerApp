//
//  CategoryCollectionViewCell.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
